using Models.Dictionary;
using Repository.Base;
using Repository.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models;
using System.Data.SqlClient;
using System.Data;

namespace Repository.Dictionary
{
    public class TaskRepository : BaseRepository<TaskJob>, ITaskRepository
    {
        /// <summary>
        /// hàm chuyển đổi trạng thái
        /// </summary>
        /// <param name="status">trạng thái mới</param>
        /// <param name="ID">Id bản ghi</param>
        /// <returns></returns>
        public int ChangeStatus(bool status, long ID)
        {

            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        sqlCommand.CommandType = CommandType.Text;
                        sqlCommand.CommandText = "UPDATE dbo.Task SET completed = @status WHERE id = @ID";
                        sqlCommand.Parameters.AddWithValue("@status", status);
                        sqlCommand.Parameters.AddWithValue("@ID", ID);

                        //sqlCommand.Parameters.Add(new SqlParameter("@status", System.Data.SqlDbType.Bit).Value = status);
                        //sqlCommand.Parameters.Add(new SqlParameter("@ID", System.Data.SqlDbType.Int).Value = ID);
                        return sqlCommand.ExecuteNonQuery();
                    }
                }
            }
        }
    }
}