// Reset Neo4j database - removes all nodes, relationships, and constraints
// Run this in Neo4j Browser or via: cat reset_neo4j.cypher | cypher-shell -u neo4j -p <password>

// 1. Delete all nodes and relationships
MATCH (n) DETACH DELETE n;

// 2. Show existing constraints
SHOW CONSTRAINTS;

// 3. Drop all constraints (run individually after checking SHOW CONSTRAINTS output)
// Example: DROP CONSTRAINT constraint_name_here;
