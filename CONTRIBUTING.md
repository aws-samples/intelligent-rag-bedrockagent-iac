// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.

// SPDX-License-Identifier: MIT-0


# Contributing Guidelines

Please read through this document before submitting any merge requests to ensure we have all the necessary information to effectively review your changes.


## Contributing via Merge Requests

Contributions via merge requests are mandatory.

Before sending the team a merge request, please ensure that:

1. You check existing open, and recently merged, merge requests to make sure someone else hasn't addressed the problem already.
1. Your change is related to an existing user story that has been refined and approved.
1. Create a branch. Development happens on feature and bug-fix branches that branch off of the main branch.
    * Name feature branches **feature/feature-name**.
    * Name bug-fix branches **fix/bugfix-name**.
1. Modify the source; please focus on the specific change you are contributing. If you also reformat all the code, it will be hard for the reviewers to focus on your change.
1. Ensure local tests and pre-commit hooks pass.
1. Commit to your branch using clear commit messages.

To create a merge request, please:

1. Raise a draft/WIP merge request to get early feedback or start a discussion whenever necessary.
1. Create a merge request, answering any default questions in the merge request interface. A reviewer should be assigned and start reviewing in less than 24 hours. If nobody is available, inform your team lead ASAP. Users defined in the [CODEOWNERS](./CODEOWNERS) file will be automatically requested for review when someone opens a merge request.
1. Pay attention to any automated CI failures reported in the merge request, and stay involved in the conversation.
1. Add a comment with a link to the merge request in your user story and inform the team in Slack that you are ready for a review.

[creating a merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html).

When reviewing a merge request:

1. Validate that the CI steps have executed successfully.
1. Validate that the change aligns with the team’s coding practices and [Amazon Internal Code Review Guidelines]
1. Ensure that you follow-up on your request for any change requests or MR comments.
1. If you won’t be around to follow-up (e.g., on PTO), ensure that you notify the MR author and agree on what will be the next steps.

## Merging and Releasing

1. Use Git Squash to merge merge requests to the main branch to condense the commit messages into one commit. This help removing the abundance of superfluous commit messages that do nothing more than muddle up a git log.
1. Delete the merged branch from the repository.
1. Create a release using automatically generated release notes and tags based on [semantic versioning](https://semver.org/) guidelines.

    > Release titles and tags should be `vX.X.X`
