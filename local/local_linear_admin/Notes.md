# Notes on linear

- Team and project IDs are UUIDs

- Labels are per team

- Can access labels filtered by name with
    var labels = await team.labels({
            filter: {
                name: { in: [...tags, route] }
            },
        });
        


