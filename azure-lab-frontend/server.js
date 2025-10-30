// server.js
import express from "express";
import axios from "axios";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import cors from "cors";

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(express.static("public"));

const GITHUB_API = "https://api.github.com/repos";
const OWNER = process.env.GITHUB_OWNER;
const REPO = process.env.GITHUB_REPO;
const WORKFLOW_FILE = "terraform.yml"; // matches your workflow file
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;

// 🟢 Create or 🔴 Destroy Lab Workflow Trigger
app.post("/trigger-workflow", async (req, res) => {
  const { firstName, lastName, email, action } = req.body;

  try {
    const response = await axios.post(
      `${GITHUB_API}/${OWNER}/${REPO}/actions/workflows/${WORKFLOW_FILE}/dispatches`,
      {
        ref: "main", // or the branch name containing your terraform.yml
        inputs: {
          action: action, // apply or destroy
          resource_group_name: "tfstate-rg",
          storage_account_name: "tfstatejayesh4890patil1",
          container_name: "tfstate",
          state_key: "terraform.tfstate"
        }
      },
      {
        headers: {
          Authorization: `Bearer ${GITHUB_TOKEN}`,
          Accept: "application/vnd.github.v3+json"
        }
      }
    );

    res.status(200).json({
      message: `Terraform ${action} triggered successfully!`,
      workflow_url: `https://github.com/${OWNER}/${REPO}/actions`
    });
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({
      error: "Failed to trigger workflow",
      details: error.response?.data || error.message
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
