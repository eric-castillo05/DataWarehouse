#ifndef BD_CONNECT_H
#define BD_CONNECT_H

#include <memory>
#include <pqxx/pqxx>
#include <string>

class DatabaseConnection {
public:
  DatabaseConnection(const std::string &conn_str);

  ~DatabaseConnection() = default;

  pqxx::connection &get_connection();

private:
  std::unique_ptr<pqxx::connection> conn;
};

#endif
