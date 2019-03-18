using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using VigShop.Models;

namespace VigShop.DatabaseAccess
{
    /// <summary>
    /// class accessDatabase thiết lập kết nối tới database để lấy về các dữ liệu cần thiết
    /// demo lấy ra danh sách nhóm thực đơn
    /// </summary>
    public class AccessDatabase : IDisposable
    {
        //khai báo connection String
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["nvcuong"].ConnectionString;
        //tạo đường kết nối trên cây cầu đã được dựng sau đó tạo phương tiện để lấy dữ liệu
        SqlConnection _sqlConnection;
        SqlCommand _sqlCommand;
        

        //khởi tạo kết nối( cây cầu) và phương tiện bằng constructor
        public AccessDatabase()
        {
            if(_sqlConnection == null)
            {
                _sqlConnection = new SqlConnection(_connectionString);
            }
            if(_sqlConnection.State == ConnectionState.Closed)
            {
                _sqlConnection.Open();
            }
            if(_sqlCommand == null)
            {
                _sqlCommand = _sqlConnection.CreateCommand();
            }
        }
        public object GetData(int currentPage, int pageSize, string where)
        {
            //lấy dữ liệu bằng cách nào
            _sqlCommand.CommandType = System.Data.CommandType.StoredProcedure;
            //lấy dữ liệu từ đâu
            _sqlCommand.CommandText = "dbo.Proc_GetMenuGroup";
            //lấy dữ liệu theo tiêu chí nào? dua vao cau truy van where
            _sqlCommand.Parameters.AddWithValue("@CurrentPage", currentPage);
            _sqlCommand.Parameters.AddWithValue("@PageSize", pageSize);
            _sqlCommand.Parameters.AddWithValue("@Where", where);
            //khai báo params output
            //sử dụng function Add để khởi tạp và thêm kiểu dữ liệu cho biến output
            _sqlCommand.Parameters.Add("@TotalRecord", SqlDbType.Int);
            _sqlCommand.Parameters["@TotalRecord"].Direction = ParameterDirection.Output;// output=
            _sqlCommand.Parameters.Add("@TotalPage", SqlDbType.Int);
            _sqlCommand.Parameters["@TotalPage"].Direction = ParameterDirection.Output;//output=
            //tham so khong can lay vi co the dung trick o giao dien
            //_sqlCommand.Parameters.Add("@startIndex", SqlDbType.Int);
            //_sqlCommand.Parameters["@startIndex"].Direction = ParameterDirection.Output;// out
            //_sqlCommand.Parameters.Add("@endIndex", SqlDbType.Int);
            //_sqlCommand.Parameters["@endIndex"].Direction = ParameterDirection.Output;//out

            //truyền các biến từ client vào đây, cũng như khởi tạo các biến để hứng output từ proceduce

            //tạo mảng đối tượng để hứng dữ liệu truyển về
            List<menuGroup> menuGroups = new List<menuGroup>();
            //thực hiện lấy dữ liệu = ADO sau đó add vào List
            using (SqlDataReader sqlDataReader = _sqlCommand.ExecuteReader())
            {
                while (sqlDataReader.Read())
                {
                    menuGroup gr = new menuGroup();
                    //duyệt qua từng bản ghi
                    for (int i = 0; i < sqlDataReader.FieldCount; i++)
                    {
                        //tách lấy tên cột
                        string fieldName = sqlDataReader.GetName(i);
                        //tách lấy giá trị tương ứng : ô
                        var fieldValue = sqlDataReader.GetValue(i);
                        //kiểm tra giá trị có bị bỏ trống không, tên field trùng với tên cột
                        if (gr.GetType().GetProperty(fieldName) != null && fieldValue != DBNull.Value)
                        {
                            gr.GetType().GetProperty(fieldName).SetValue(gr, fieldValue);
                        }
                    }
                    menuGroups.Add(gr);

                }
            }
            //lấy giá trị output của totalRecord và totalPage
            int totalRecord = Convert.ToInt32(_sqlCommand.Parameters["@TotalRecord"].Value);
            int totalPage = Convert.ToInt32(_sqlCommand.Parameters["@TotalPage"].Value);
            object menuCategory = new
            {
                Data = menuGroups,
                TotalPage=totalPage,
                TotalRecord=totalRecord
            };
                 return menuCategory;
            
        }
        /// <summary>
        /// gửi request duy nhất 1 lần và không nên lưu lại
        /// </summary>
        public void Dispose()
        {
            if (_sqlConnection.State == ConnectionState.Open)
            {
                _sqlConnection.Close();
            }
        }
    }
}