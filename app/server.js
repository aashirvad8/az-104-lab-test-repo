import express from "express";
import bodyParser from "body-parser";
import fs from "fs-extra";
import { exec } from "child_process";
import path from "path";

const app = express();
const PORT = 3000;
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => res.render("index"));

app.post("/submit", async (req, res) => {
  const { first_name, last_name, email, batch_number, mobile, city, action } = req.body;
  const emailPrefix = email.split("@")[0].replace(/[^a-zA-Z0-9]/g, "").toLowerCase();

  const tfvarsPath = path.join("..", "terraform-resources", "terraform.tfvars");
  let tfvars = await fs.readFile(tfvarsPath, "utf8");

  const rgName = `${emailPrefix}-rg`;
  const vnetName = `${emailPrefix}-vnet`;
  const vmName = `${emailPrefix}-vm`;

  tfvars = tfvars
    .replace(/rg_Name\s*=.*/g, `rg_Name = "${rgName}"`)
    .replace(/vnet_Name\s*=.*/g, `vnet_Name = "${vnetName}"`)
    .replace(/vm_name\s*=.*/g, `vm_name = "${vmName}"`);

  await fs.writeFile(tfvarsPath, tfvars);

  // Build GitHub CLI command
  const workflowCmd = `gh workflow run terraform.yml \
    -f action=${action} \
    -f resource_group_name=tfstate-rg \
    -f storage_account_name=tfstatestgacfortesting \
    -f container_name=tfstate \
    -f state_key=${emailPrefix}.tfstate`;

  exec(workflowCmd, { cwd: path.join("..") }, (error, stdout, stderr) => {
    if (error) {
      console.error(stderr);
      res.send(`<h3>❌ Error running workflow:</h3><pre>${stderr}</pre>`);
    } else {
      res.send(`<h3>✅ Terraform ${action} triggered for ${email}</h3><pre>${stdout}</pre>`);
    }
  });
});

app.listen(PORT, () => console.log(`🚀 Server running at http://localhost:${PORT}`));
