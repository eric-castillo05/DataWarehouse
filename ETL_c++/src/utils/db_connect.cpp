#include "db_connect.h"
#include <pqxx/pqxx>

DatabaseConnection::DatabaseConnection(const std::string &conn_str) {
  conn = std::make_unique<pqxx::connection>(conn_str);
  if (!conn->is_open()) {
    throw std::runtime_error("Failed to connect to database");
  }
}

pqxx::connection &DatabaseConnection::get_connection() { return *conn; }
