const users = require('@arangodb/users');
const reader_username = process.env.ARANGO_READER_USERNAME;
const reader_password = process.env.ARANGO_READER_PASSWORD;
const db_name = process.env.ARANGO_DB_NAME;

if (!users.exists(reader_username)) {
  users.save(reader_username, reader_password);
  users.grantDatabase(reader_username, db_name, 'ro');
}
