import { LinearClient, Issue, IssueLabel, LinearFetch } from "@linear/sdk";
import dotenv from "dotenv";

dotenv.config();

const LINEAR_TEAM = "e55dd2f6-afeb-4d9d-b623-0704a2951135";
const LINEAR_PROJECT_ID = "2daae041-17ef-4e25-8667-4c66234d1436";

async function createIssue(userEmail: string, description: string, priority: number = 0, route: string, tags: string[] = ["Feedback"]): Promise<any> {
    const linearClient = new LinearClient({
        apiKey: process.env.LINEAR_API_KEY,
    });
    var tagsNames = [...tags, route];
    // titlecase tags
    tagsNames = tagsNames.map(tag => tag.charAt(0).toUpperCase() + tag.slice(1).toLowerCase());
    const tagIds: string[] = [];
    const team = await linearClient.team(LINEAR_TEAM);
    var labels = await team.labels({
        filter: {
            name: { in: [...tags, route] }
        },
    });

    // Check provided label names
    for (const tagName of tagsNames) {
        if (!labels.nodes.some(label => label.name === tagName)) {
            // If label name doesn't exist, create new label in linear
            const labelCreateResponse = await linearClient.createIssueLabel({
                teamId: LINEAR_TEAM,
                name: tagName
            });
            if (labelCreateResponse.success) {
                // If label created successfully, fetch labels again
                labels = await team.labels({
                    filter: {
                        name: { in: [...tags, route] }
                    },
                });
            } else {
                console.error(`Failed to create label ${tagName}`);
            }

        }
        // Add label id to tagIds
        const label = labels.nodes.find(label => label.name === tagName);
        if (label) {
            tagIds.push(label.id);
        }
    };

    // Create issue in linear
    try {
        var issueId = linearClient.createIssue({
            teamId: LINEAR_TEAM,
            priority: priority,
            projectId: LINEAR_PROJECT_ID,
            title: `Feedback from ${userEmail} on route ${route}`,
            description: description,
            labelIds: tagIds
        });
        return issueId;
    } catch (error) {
        console.error(error);
    }
}

createIssue("aran@captainapp.co.uk", "This is a test issue 3", 1, "Test",)
    .then((issueId) => { console.log(issueId) });    