# README

## Show files changed in current commit

```bash
if [[ $(git diff-tree --no-commit-id --name-only -r HEAD) = *"_posts"* ]]
then
  echo "Something in _posts/ has been updated"
fi
```

```bash
for i in $(git diff --no-commit-id --name-status -r HEAD~1 | awk '/^A/{print $2}')
do
  if [[ $i = *"_posts"* ]]
  then
    echo "$i has been added"
  fi
done
```

## BlueSky post via API

https://docs.bsky.app/docs/advanced-guides/posts

## GitHub Actions workflow

```
steps:
  - name: Do the thing
    run: ./script.sh
    # OR
    run: curl -X POST ...
```
