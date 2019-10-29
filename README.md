# git-tag-action

GitHub action that adds a lightweight git tag to the current workflow commit.

**Note:** If a tag with the same name already exists, it is replaced.

## Environment Variables

* **GITHUB_TOKEN (required)** - Required for permission to tag the repository.
* **TAG (required)** - Name of the tag to be added.

## Example usage

```yaml
uses: hole19/git-tag-action@v1
env:
  TAG: v1.2.3
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
