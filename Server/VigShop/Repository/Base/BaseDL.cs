using Models.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;

namespace Repository.Base
{
    /// <summary>
    /// Class Base xử lý chung việc truy vấn với CSDL
    /// </summary>
    /// Created by: nvcuong (29/04/2018)
    public class BaseDL
    {
        /// <summary>
        /// Thực thi một store với các tham số truyền vào
        /// </summary>
        /// <param name="storeName">Tên store cần thực thi</param>
        /// <param name="param">mảng các tham số truyền vào</param>
        /// <returns>trả về int</returns>
        /// Created by: nvcuong (19/04/2018)
        public int ExecuteNonQuery(string storeName, object[] param)
        {
            int result;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = _unitOfWork.BeginTransaction();
                        //Gán giá trị tham số:
                        SqlCommandBuilder.DeriveParameters(sqlCommand);
                        foreach (SqlParameter p in sqlCommand.Parameters)
                        {
                            var i = sqlCommand.Parameters.IndexOf(p);
                            if (i > 0 && i <= param.Length)
                            {
                                p.Value = param[i - 1];
                            }
                            else if (i > param.Length)
                            {
                                break;
                            }
                        }
                        result = sqlCommand.ExecuteNonQuery();
                        _unitOfWork.Commit();
                    }
                }
            }
            return result;
        }
        /// <summary>
        /// Thực thi câu lệnh sql lấy một giá trị đơn trả về
        /// </summary>
        /// <param name="storeName">tên store cần thực thi</param>
        /// <param name="param">mảng các tham số cần truyền vào</param>
        /// <returns>Giá trị đơn cần trả về (có thể là int, string,...)</returns>
        /// Created by: nvcuong (19/04/2018)
        public object ExecuteScalar(string storeName, object[] param)
        {
            object result;
            using (IUnitOfWork unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = unitOfWork.BeginTransaction();
                        //Gán giá trị tham số:
                        SqlCommandBuilder.DeriveParameters(sqlCommand);
                        foreach (SqlParameter p in sqlCommand.Parameters)
                        {
                            var i = sqlCommand.Parameters.IndexOf(p);
                            if (i > 0 && i <= param.Length)
                            {
                                p.Value = param[i - 1];
                            }
                            else if (i > param.Length)
                            {
                                break;
                            }
                        }
                        result = sqlCommand.ExecuteScalar();
                        unitOfWork.Commit();
                    }
                }
            }
            return result;
        }
        /// <summary>
        /// Thực thi câu lệnh sql lấy về một (hoặc List) đối tượng
        /// </summary>
        /// <param name="storeName">tên store cần thực thi</param>
        /// <param name="param">mảng các tham số cần truyền vào</param>
        /// <returns>Giá trị đơn cần trả về (có thể là int, string,...)</returns>
        /// Created by: nvcuong (19/04/2018)
        public SqlDataReader ExecuteReader(string storeName, object[] paramValue)
        {
            SqlDataReader sqlDataReader;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = _unitOfWork.BeginTransaction();
                        SqlCommandBuilder.DeriveParameters(sqlCommand);
                        foreach (SqlParameter p in sqlCommand.Parameters)
                        {
                            var i = sqlCommand.Parameters.IndexOf(p);
                            if (i > 0 && i <= paramValue.Length)
                            {
                                p.Value = paramValue[i - 1];
                            }
                            else if (i > paramValue.Length)
                            {
                                break;
                            }
                        }
                        sqlDataReader = sqlCommand.ExecuteReader();
                    }
                }
            }
            return sqlDataReader;
        }
        /// <summary>
        /// Lấy dữ liệu phân trang theo cách cũ , dữ liệu trả về 3 bảng
        /// </summary>
        /// <typeparam name="T">Đối tượng</typeparam>
        /// <param name="storeName">Tên Store sẽ lấy dữ liệu</param>
        /// <param name="paramValue">Mảng tham số truyền vào theo thứ tự</param>
        /// <returns>Bảng dữ liệu đã được phân trang</returns>
        /// Created by: nvcuong (21/06/2018)

        public virtual Paging<T> SelectEntitiesPaging<T>(string storeName, object[] paramValue)
        {
            Paging<T> pagingEntities = new Paging<T>();
            List<T> entities = new List<T>();
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection _conn = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand command = _conn.CreateCommand())
                    {

                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandText = storeName;
                        //command.Transaction = _unitOfWork.BeginTransaction();
                        //Gán giá trị tham số:

                        int currentPage = Convert.ToInt32(paramValue[0]);
                        int pageSize = Convert.ToInt32(paramValue[1]);
                        string where = Convert.ToString(paramValue[2]);


                        //lấy dữ liệu theo tiêu chí nào? dua vao cau truy van where
                        command.Parameters.AddWithValue("@CurrentPage", currentPage);
                        command.Parameters.AddWithValue("@PageSize", pageSize);
                        command.Parameters.AddWithValue("@Where", where);
                        //khai báo params output
                        //sử dụng function Add để khởi tạp và thêm kiểu dữ liệu cho biến output
                        command.Parameters.Add("@TotalRecord", SqlDbType.Int);
                        command.Parameters["@TotalRecord"].Direction = ParameterDirection.Output;// output=
                        command.Parameters.Add("@TotalPage", SqlDbType.Int);
                        command.Parameters["@TotalPage"].Direction = ParameterDirection.Output;//output=

                        using (SqlDataReader sqlDataReader = command.ExecuteReader())
                        {
                            while (sqlDataReader.Read())
                            {
                                var entity = Activator.CreateInstance<T>();
                                //duyệt qua từng bản ghi
                                for (int i = 0; i < sqlDataReader.FieldCount; i++)
                                {
                                    //tách lấy tên cột
                                    string fieldName = sqlDataReader.GetName(i);
                                    //tách lấy giá trị tương ứng : ô
                                    var fieldValue = sqlDataReader.GetValue(i);
                                    //kiểm tra giá trị có bị bỏ trống không, tên field trùng với tên cột
                                    if (entity.GetType().GetProperty(fieldName) != null && fieldValue != DBNull.Value)
                                    {
                                        entity.GetType().GetProperty(fieldName).SetValue(entity, fieldValue);
                                    }
                                }
                                entities.Add(entity);

                            }
                        }
                        //lấy ouput số trang
                        //lấy giá trị output của totalRecord và totalPage
                        int totalRecord = Convert.ToInt32(command.Parameters["@TotalRecord"].Value);
                        int totalPage = Convert.ToInt32(command.Parameters["@TotalPage"].Value);
                        pagingEntities = new Paging<T>() { Entities = entities, TotalPage = totalPage, TotalRecord = totalRecord };
                    }
                    //_unitOfWork.Commit();
                }
                return pagingEntities;
            }
        }
        //public virtual Paging<T> SelectEntitiesPaging<T>(string storeName, object[] paramValue)
        //{
        //    Paging<T> pagingEntities = new Paging<T>();
        //    List<T> entities = new List<T>();
        //    using (IUnitOfWork _unitOfWork = new UnitOfWork())
        //    {
        //        using (SqlConnection _conn = _unitOfWork.DataContext.Connection)
        //        {
        //            using (SqlCommand command = _conn.CreateCommand())
        //            {
        //                command.CommandType = CommandType.StoredProcedure;
        //                command.CommandText = storeName;
        //                //command.Transaction = _unitOfWork.BeginTransaction();
        //                //Gán giá trị tham số:
        //                SqlCommandBuilder.DeriveParameters(command);

        //                foreach (SqlParameter para in command.Parameters)
        //                {
        //                    var i = command.Parameters.IndexOf(para);
        //                    if (i > 0 && i <= paramValue.Length)
        //                    {
        //                        para.Value = paramValue[i - 1];
        //                    }
        //                    else if (i > paramValue.Length)
        //                    {
        //                        break;
        //                    }
        //                }

        //                SqlDataAdapter adapter = new SqlDataAdapter(command);
        //                DataSet dataset = new DataSet();

        //                adapter.Fill(dataset);
        //                if (dataset.Tables.Count > 0)
        //                {
        //                    DataTable tableEntities = dataset.Tables[0];
        //                    // DataTable tableTotalPage = dataset.Tables[1];
        //                    //  DataTable tableTotalRecord = dataset.Tables[2];

        //                    foreach (DataRow row in tableEntities.Rows)
        //                    {
        //                        var entity = Activator.CreateInstance<T>();
        //                        foreach (DataColumn column in tableEntities.Columns)
        //                        {
        //                            string columnName = column.ColumnName;
        //                            //var abc = row[column];
        //                            if (entity.GetType().GetProperty(columnName) != null && row[columnName] != DBNull.Value)
        //                            {
        //                                entity.GetType().GetProperty(columnName).SetValue(entity, row[columnName], null);
        //                            }
        //                        }
        //                        entities.Add(entity);
        //                    }

        //                    int totalRecord = int.Parse(tableEntities.Rows[0][0].ToString());
        //                    int totalPage = int.Parse(tableEntities.Rows[0][1].ToString());
        //                    pagingEntities = new Paging<T>() { Entities = entities, TotalPage = totalPage, TotalRecord = totalRecord };
        //                }
        //            }
        //        }
        //        //_unitOfWork.Commit();
        //    }
        //    return pagingEntities;
        //}
        /// <summary>
        /// Lấy một mảng dữ liệu cho Entity
        /// </summary>
        /// <param name="storeName">Tên store procedure</param>
        /// <returns>Mãng dữ liệu kiểu Entity</returns>
        /// Created by: nvcuong (13/04/2018)
        public IEnumerable<T> GetEntities<T>(string storeName)
        {
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection _conn = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand command = _conn.CreateCommand())
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandText = storeName;
                        command.Transaction = _unitOfWork.BeginTransaction();
                        using (var sqlDataReader = command.ExecuteReader())
                        {
                            while (sqlDataReader.Read())
                            {
                                var entity = Activator.CreateInstance<T>();
                                for (int i = 0; i < sqlDataReader.FieldCount; i++)
                                {
                                    string fieldName = sqlDataReader.GetName(i);
                                    PropertyInfo property = entity.GetType().GetProperty(fieldName);
                                    if (property != null && sqlDataReader[fieldName] != DBNull.Value)
                                    {
                                        property.SetValue(entity, sqlDataReader[fieldName], null);
                                    }
                                }
                                yield return entity;
                            }
                        }
                    }
                }
                //_unitOfWork.Commit();
            }
        }

        /// <summary>
        /// Lấy mảng dữ liệu Entity với tham số truyền vào theo store và điều kiện là mảng tham số được gắn vào object
        /// </summary>
        /// <typeparam name="T">Entity</typeparam>
        /// <param name="storeName"> Tên store</param>
        /// <param name="paramValue">mảng các tham số truyền vào</param>
        /// <returns>List Entity</returns>
        /// Created By: nvcuong (30/06/2018)
        protected virtual IEnumerable<T> GetEntities<T>(string storeName, object[] paramValue)
        {
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection _conn = _unitOfWork.DataContext.Connection)
                {
                    using (var command = _unitOfWork.DataContext.Connection.CreateCommand())
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandText = storeName;
                        command.Transaction = _unitOfWork.BeginTransaction();
                        //Gán giá trị các tham số đầu vào cho store:
                        SqlCommandBuilder.DeriveParameters(command);
                        foreach (SqlParameter p in command.Parameters)
                        {
                            var i = command.Parameters.IndexOf(p);
                            if (i > 0 && i <= paramValue.Length)
                            {
                                p.Value = paramValue[i - 1];
                            }
                            else if (i > paramValue.Length)
                            {
                                break;
                            }
                        }
                        SqlDataReader sqlDataReader = command.ExecuteReader();

                        while (sqlDataReader.Read())
                        {
                            var entity = Activator.CreateInstance<T>();
                            for (int i = 0; i < sqlDataReader.FieldCount; i++)
                            {
                                string fieldName = sqlDataReader.GetName(i);
                                if (entity.GetType().GetProperty(fieldName) != null && sqlDataReader[fieldName] != DBNull.Value)
                                {
                                    entity.GetType().GetProperty(fieldName).SetValue(entity, sqlDataReader[fieldName], null);
                                }
                            }
                            yield return entity;
                        }

                    }
                }
                //_unitOfWork.Commit();
            }
        }
        /// <summary>
        /// Lấy danh sách đối tượng theo trang dữ liệu lấy ra từ procedure dưới dạng 1 bảng và 2 output
        /// </summary>
        /// <typeparam name="T">đối tượng bảng cần lấy dữ lieuu</typeparam>
        /// <param name="sql"></param>
        /// <param name="sqlTotal"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="total"></param>
        /// Createby: nvcuong
        /// Createdate: 30/06/2018
        public IEnumerable<T> GetEntitiesPaging<T>(string storeName, string sqlTotal, int start, int limit, out int total)
        {
            List<T> lstObject = new List<T>();
            total = 0;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (var cmd = sqlConnection.CreateCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@sort", "");
                        cmd.Parameters.AddWithValue("@start", start);
                        cmd.Parameters.AddWithValue("@limit", limit);
                        cmd.Parameters.Add("@outValue", SqlDbType.Int);
                        cmd.Parameters["@outValue"].Direction = ParameterDirection.Output;
                        SqlDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            var entity = Activator.CreateInstance<T>();
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                string fieldName = reader.GetName(i);
                                if (entity.GetType().GetProperty(fieldName) != null && reader[fieldName] != DBNull.Value)
                                {
                                    entity.GetType().GetProperty(fieldName).SetValue(entity, reader[fieldName], null);
                                }
                            }
                            lstObject.Add(entity);
                        }
                        //conn.Close();

                        //conn.Open();
                        SqlCommand cmd2 = new SqlCommand(sqlTotal, sqlConnection);
                        total = (int)cmd2.ExecuteScalar();
                    }
                }
            }
            //conn.Close();
            return lstObject;
        }
        /// <summary>
        /// Thêm, sửa Entity (tùy biến Store truyền vào)
        /// </summary>
        /// <typeparam name="T">entity</typeparam>
        /// <typeparam name="storeName">Tên store thực hiện cập nhật dữ liệu</typeparam>
        /// Người tạo: nvcuong
        /// Ngày tạo: 30/06/2018
        /// <returns>Số lượng bản ghi thêm/sửa thành công</returns>
        public int Update<T>(T entity, string storeName)
        {
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = _unitOfWork.BeginTransaction();
                        SqlCommandBuilder.DeriveParameters(sqlCommand);
                        foreach (SqlParameter item in sqlCommand.Parameters)
                        {
                            string parameterName = item.ParameterName.Replace("@", string.Empty);

                            if (entity.GetType().GetProperty(parameterName) != null)
                            {
                                var parameterValue = entity.GetType().GetProperty(parameterName).GetValue(entity, null);
                                item.Value = (parameterValue != null ? parameterValue : DBNull.Value);
                            }
                            else
                            {
                                item.Value = DBNull.Value;
                            }
                        }
                        var result = sqlCommand.ExecuteNonQuery();
                        _unitOfWork.Commit();
                        return result;
                    }
                }
            }
        }
        /// <summary>
        /// Hàm thêm một món ăn hoặc thêm một món ăn và thêm nhiều nguyên vật liệu để định dạng nguyên vật liệu
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="entity">Một đối tượng (Food)</param>
        /// <param name="storeName">Tên store</param>
        /// <param name="connectWithFood">Mảng các nguyên vật liệu</param>
        /// <returns></returns>
        /// Created by: nvcuong 27/09/2018
        //public int UpdateMulti<T>(T entity, string storeName, FoodMaterial[] foodMaterials)
        //{
        //    /*
        //     * Tạo một DataTable add dữ liệu vào type Table trong SQl
        //     */
        //    DataTable tableConnectWithFood = new DataTable();
        //    tableConnectWithFood.Columns.Add(new DataColumn("foodID", typeof(Guid)));
        //    tableConnectWithFood.Columns.Add(new DataColumn("materialID", typeof(int)));
        //    tableConnectWithFood.Columns.Add(new DataColumn("foodMaterialAmount", typeof(int)));
        //    foreach (var item in foodMaterials)
        //    {
        //        tableConnectWithFood.NewRow();
        //        tableConnectWithFood.Rows.Add(item.FoodID, item.MaterialID, item.FoodMaterialAmount);
        //    }
        //    //Không thể thêm được dòng

        //    //Truyền tham số vào store proceduce
        //    using (IUnitOfWork _unitOfWork = new UnitOfWork())
        //    {
        //        using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
        //        {
        //            using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
        //            {
        //                sqlCommand.CommandType = CommandType.StoredProcedure;
        //                sqlCommand.CommandText = storeName;
        //                sqlCommand.Transaction = _unitOfWork.BeginTransaction();
        //                SqlCommandBuilder.DeriveParameters(sqlCommand);
        //                foreach (SqlParameter item in sqlCommand.Parameters)
        //                {
        //                    string parameterName = item.ParameterName.Replace("@", string.Empty);

        //                    if (entity.GetType().GetProperty(parameterName) != null)
        //                    {
        //                        var parameterValue = entity.GetType().GetProperty(parameterName).GetValue(entity, null);
        //                        item.Value = (parameterValue != null ? parameterValue : DBNull.Value);
        //                    }
        //                    else
        //                    {
        //                        item.Value = DBNull.Value;
        //                    }
        //                }
        //                //Thêm bản liên kết vào store
        //                SqlParameter tvparam = sqlCommand.Parameters["@ConnectWithFood"];
        //                sqlCommand.Parameters["@ConnectWithFood"].Value = tableConnectWithFood;
        //                tvparam.SqlDbType = SqlDbType.Structured;
        //                tvparam.TypeName = "dbo.ConnectWithFood";
        //                var result = sqlCommand.ExecuteNonQuery();
        //                _unitOfWork.Commit();
        //                return result;
        //            }
        //        }
        //    }
        //}
        /// <summary>
        /// Xóa dữ liệu
        /// </summary>
        /// <param name="storeName">tên store thực hiện xóa dữ liệu</param>
        /// <param name="nameParameters">mảng bao gồm TÊN các tham số truyền vào cho store (theo thứ tự trong store)</param>
        /// <param name="valueParameters">mảng bao gồm GIÁ TRỊ các tham số truyền vào cho store (theo thứ tự trong store)</param>
        /// <param name="numberParameter">số lượng tham số</param>
        /// Create by: nvcuong
        /// Create date: 30/06/2018
        /// <returns></returns>
        public virtual int Delete(string storeName, string[] nameParameters, object[] valueParameters, int numberParameter)
        {
            var result = 0;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (var sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = _unitOfWork.BeginTransaction();
                        for (int i = 0; i < numberParameter; i++)
                        {
                            sqlCommand.Parameters.AddWithValue(nameParameters[i], valueParameters[i]);
                        }
                        result = sqlCommand.ExecuteNonQuery();
                        _unitOfWork.Commit();
                    }
                }
            }
            return result;
        }
        /// <summary>
        /// Xóa dữ liệu với nhiều tham số đầu vào
        /// </summary>
        /// <param name="sql">Tên store</param>
        /// <param name="param">Mảng các tham số truyền vào</param>
        /// <returns></returns>
        /// Created by: nvcuong (19/04/2018)
        public virtual int Delete(string storeName, object[] param)
        {
            var result = 0;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (var sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Transaction = _unitOfWork.BeginTransaction();
                        SqlCommandBuilder.DeriveParameters(sqlCommand);

                        int countParameters = sqlCommand.Parameters.Count - 1; // Bỏ qua param @RETURN_VALUE của các store
                        if (param.Length >= countParameters)
                        {
                            for (int i = 1; i <= countParameters; i++)
                            {
                                sqlCommand.Parameters[i].Value = param[i - 1];
                            }
                        }
                        else
                        {
                            throw new System.ArgumentException("Tham số đầu vào cho store không đủ", "Error");
                        }
                        result = sqlCommand.ExecuteNonQuery();
                        _unitOfWork.Commit();
                    }
                }
            }
            return result;
        }
        /// <summary>
        ///Xóa dữ liệu bảng nhóm món ăn
        /// </summary>
        /// <param name="storeName">Tên store</param>
        /// <param name="foodIDs"></param>
        /// <returns></returns>
        /// Created by: nvcuong 21/10/2018
        public int DeleteFood(string storeName, string groupId)
        {

            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.CommandText = storeName;
                        sqlCommand.Parameters.AddWithValue("@groupID", groupId);
                        return sqlCommand.ExecuteNonQuery();
                    }
                }
            }
        }

    }
}