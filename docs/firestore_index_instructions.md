# Firestore Composite Index Instructions

When encountering an error like:
```
[cloud_firestore/failed-precondition] The query requires an index.
```
it means that your query demands a composite index with fields in the exact order used in the query.

For your current query in FirestoreQueries:
- If excluding the current user, the query uses:
  1. Filter & orderBy: `authorId` (inequality filter, ascending)
  2. Filter: `isDeleted` (equality filter – include an explicit orderBy)
  3. OrderBy: `createdAt` (descending)

## Steps to Verify/Resolve

1. In the Firebase Console, go to the Firestore Indexes page.
2. Check that you have a composite index defined with:
   - Field: `authorId` set to Ascending  
   - Field: `isDeleted` set to Ascending  
   - Field: `createdAt` set to Descending
3. Ensure that the index is fully built (not still in a building state).
4. If the index order does not exactly match, delete and recreate the index with the correct order.
5. No changes to your Firestore rules are required; they already allow read and list operations for posts.

For more details, see the [Firestore documentation on indexes](https://firebase.google.com/docs/firestore/query-data/index-overview).
