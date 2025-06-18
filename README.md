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
    echo "$i is a new post"
  else
    echo "$i is not a post"
  fi
done
```

## Post to BlueSky

1. Add to GitHub Secrets
  - APP_PASSWORD

```bash
# Resolve DID for handle
HANDLE='mitchnemirovsky.bsky.social'
DID_URL="https://bsky.social/xrpc/com.atproto.identity.resolveHandle"
export DID=$(curl -G \
    --data-urlencode "handle=$HANDLE" \
    "$DID_URL" | jq -r .did)

# Get an app password from here: https://staging.bsky.app/settings/app-passwords
export APP_PASSWORD=myapppassword

# Get API key with the app password
API_KEY_URL='https://bsky.social/xrpc/com.atproto.server.createSession'
POST_DATA="{ \"identifier\": \"${DID}\", \"password\": \"${APP_PASSWORD}\" }"
export API_KEY=$(curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$POST_DATA" \
    "$API_KEY_URL" | jq -r .accessJwt)

# Get a user's feed
ACTOR='mitchnemirovsky.bsky.social'
LIMIT=4
FEED_URL="https://bsky.social/xrpc/app.bsky.feed.getAuthorFeed"
curl -G \
    -H "Authorization: Bearer ${API_KEY}" \
    --data-urlencode "actor=$ACTOR" \
    --data-urlencode "limit=$LIMIT" \
    "$FEED_URL" | jq -r .feed # Or if you want to return only a user's own posts: jq '.feed | .[] | select((.post.record."$type" == "app.bsky.feed.post") and (.post.record.reply.parent? | not) and (.reason? | not)) | {text: .post.record.text, createdAt: .post.record.createdAt, replyCount: .post.replyCount, repostCount: .post.repostCount, likeCount: .post.likeCount, author: {handle: .post.author.handle, displayName: .post.author.displayName, avatar: .post.author.avatar}}'

# Post "Hello, world" to your feed
POST_FEED_URL='https://bsky.social/xrpc/com.atproto.repo.createRecord'
POST_RECORD="{ \"collection\": \"app.bsky.feed.post\", \"repo\": \"${DID}\", \"record\": { \"text\": \"Hello, world\", \"createdAt\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\", \"\$type\": \"app.bsky.feed.post\" } }"
curl -X POST \
    -H "Authorization: Bearer ${API_KEY}" \
    -H 'Content-Type: application/json' \
    -d "$POST_RECORD" \
    "$POST_FEED_URL" | jq -r
```
