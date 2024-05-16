
import {LinearClient} from "@linear/sdk";

import dotenv from "dotenv";

dotenv.config();

const linearClient = new LinearClient({
  apiKey: process.env.LINEAR_API_KEY,
});

// Fetch the project by ID
const fetchProject = async (projectId: string) => {
  const project = await linearClient.project(projectId);

  return project;
};


fetchProject("2daae041-17ef-4e25-8667-4c66234d1436").then((project) => {
  console.log(project.state);
});
