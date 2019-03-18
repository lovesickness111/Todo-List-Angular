using Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Repository.DatabaseAccess
{
    /// <summary>
    /// tùy chọn thiết lập kết nối đến database
    /// </summary>
    public class DatabaseContext : IDatabaseContext
    {
        private readonly string _connectionString;
        private SqlConnection _connection;
        /// <summary>
        /// khởi tạo đối tượng tạo chuỗi kết nối mới
        /// </summary>
        public DatabaseContext()
        {
            string keyConnection = CommonUtility.GetAppSettingByKey("KeyConnection");
            _connectionString = ConfigurationManager.ConnectionStrings[keyConnection].ConnectionString; 
        }
        /// <summary>
        /// hàm triển khai từ interface
        /// thiết lập kết nối nếu đang đóng
        /// </summary>
        public SqlConnection Connection
        {
            get
            {
                if (_connection == null)
                {
                    _connection = new SqlConnection(_connectionString);
                }
                if (_connection.State != ConnectionState.Open)
                {
                    _connection.Open();
                }
                return _connection;
            }
        }


        public void Dispose()
        {
            if (_connection != null && _connection.State == ConnectionState.Open)
                _connection.Close();
        }
    }
}