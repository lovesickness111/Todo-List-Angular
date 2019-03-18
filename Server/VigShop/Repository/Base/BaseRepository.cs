using Models.Common;
using Repository.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Repository.Base
{
    /// <summary>
    /// Base Repository thực hiện thao tác với CSDL
    /// </summary>
    /// <typeparam name="T">Entity ảnh hưởng</typeparam>
    /// Created by: nvcuong (01/03/2018)
    public class BaseRepository<T> : BaseDL, IBaseRepository<T> where T : class, new()
    {
        #region DECLARE

        //private SqlConnection _sqlConnectionChildren;

        //private readonly IUnitOfWork _unitOfWorkChildren;

        //private SqlTransaction _sqlTransactionChildren;

        #endregion

        #region Constructor
        /// <summary>
        /// Khởi tạo Base Repository
        /// </summary>
        /// <param name="unitOfWork">Unit of work</param>
        /// Created by: nvcuong (01/02/2018)\
        /// Edit by nvcuong - sửa lại Sqlconnection ()
        //public BaseRepository(IUnitOfWork unitOfWork)
        //{
        //if (unitOfWork != null)
        //{
        //    _unitOfWorkChildren = unitOfWork;
        //    _sqlConnectionChildren = base._sqlConnection;
        //    _sqlTransactionChildren = base._sqlTransaction;
        //}
        //else
        //{
        //    throw new ArgumentNullException("unitOfWork");
        //}
        //}
        #endregion

        #region Base Method - các phương thức Base
        /// <summary>
        /// Thực thi một store với các tham số truyền vào
        /// </summary>
        /// <param name="storeName">Tên store cần thực thi</param>
        /// <param name="param">mảng các tham số truyền vào</param>
        /// <returns></returns>
        /// Created by: nvcuong (19/04/2018)
        public new int ExecuteNonQuery(string storeName, object[] param)
        {
            return base.ExecuteNonQuery(storeName, param);
        }

        /// <summary>
        /// Thực thi câu lệnh sql lấy một giá trị đơn trả về
        /// </summary>
        /// <param name="storeName">tên store cần thực thi</param>
        /// <param name="param">mảng các tham số cần truyền vào</param>
        /// <returns>Giá trị đơn cần trả về (có thể là int, string,...)</returns>
        /// Created by: nvcuong (19/04/2018)
        public new object ExecuteScalar(string storeName, object[] param)
        {
            return base.ExecuteScalar(storeName, param);
        }

        /// <summary>
        /// Thực thi câu lệnh sql lấy về một (hoặc List) đối tượng
        /// </summary>
        /// <param name="storeName">tên store cần thực thi</param>
        /// <param name="param">mảng các tham số cần truyền vào</param>
        /// <returns>Giá trị đơn cần trả về (có thể là int, string,...)</returns>
        /// Created by: nvcuong (19/04/2018)
        public new SqlDataReader ExecuteReader(string storeName, object[] paramValue)
        {
            return base.ExecuteReader(storeName, paramValue);
        }

        /// <summary>
        /// Lấy một mảng dữ liệu cho Entity
        /// </summary>
        /// <returns>Mảng dữ liệu</returns>
        /// Created By: nvcuong (19/04/2018)
        public IEnumerable<T> GetEntities()
        {
            return base.GetEntities<T>(GenerateProcUtility<T>.GetListEntity());
        }

        /// <summary>
        /// Lấy một mảng dữ liệu cho Entity
        /// </summary>
        /// <param name="storeName">Tên store procedure</param>
        /// <returns>Mảng dữ liệu kiểu Entity</returns>
        /// Created by: nvcuong (13/04/2018)
        public IEnumerable<T> GetEntities(string storeName)
        {
            return base.GetEntities<T>(storeName);
        }

        /// <summary>
        /// Lấy mảng dữ liệu Entity theo store và điều kiện 1 đối tượng truyền vào
        /// </summary>
        /// <typeparam name="T">Entity</typeparam>
        /// <param name="storeName"> Tên store</param>
        /// <param name="paramValue">mảng các tham số truyền vào</param>
        /// <returns>List Entity</returns>
        /// Created By: nvcuong (30/06/2015)
        public IEnumerable<T> GetEntities(string storeName, object[] paramValue)
        {
            return base.GetEntities<T>(storeName, paramValue);
        }

        /// <summary>
        /// Lấy danh sách đối tượng theo trang
        /// đẩy láo nên không dùng
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="sql"></param>
        /// <param name="sqlTotal"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="total"></param>
        /// Createby: nvcuong
        /// Createdate: 30/06/2015
        public IEnumerable<T> GetEntitiesPaging(string storeName, string sqlTotal, int start, int limit, out int total)
        {
            List<T> lstObject = new List<T>();
            total = 0;
            using (IUnitOfWork _unitOfWork = new UnitOfWork())
            {
                using (SqlConnection sqlConnection = _unitOfWork.DataContext.Connection)
                {
                    using (var cmd = sqlConnection.CreateCommand())
                    {
                        //SqlCommand cmd = new SqlCommand(sql, conn);
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
        /// Thêm mới Entity - sử dụng store thực thi tự sinh trên chương trình
        /// </summary>
        /// <param name="entity">entity truyền vào</param>
        /// <returns>Số lượng bản ghi thêm mới thành công</returns>
        /// Created by: nvcuong (17/04/2018)
        public int Insert(T entity)
        {
            string storeInsertName = GenerateProcUtility<T>.InsertEntity();
            return Update(entity, storeInsertName);
        }

        /// <summary>
        /// Thêm mới Entity - tự truyền tên store sẽ thực thi
        /// </summary>
        /// <param name="entity">entity truyền vào</param>
        /// <param name="storeName">Tên store thực hiện thêm mới</param>
        /// <returns>Số lượng bản ghi thêm mới thành công</returns>
        /// Created by: nvcuong (17/04/2018)
        public int Insert(T entity, string storeInsertName)
        {
            return Update(entity, storeInsertName);
        }

        /// <summary>
        /// Cập nhật (có thể là thêm mới hoặc sửa) Entity (store thực hiện cập nhật chương trình sẽ tự sinh theo Template)
        /// </summary>
        /// <param name="entity">Entity truyền vào</param>
        /// <returns>Số lượng bản ghi cập nhật thành công</returns>
        /// Created By: nvcuong (17/04/2017)
        public int Update(T entity)
        {
            return base.Update<T>(entity, GenerateProcUtility<T>.UpdateEntity());
        }

        /// <summary>
        /// Thêm, sửa Entity (tùy biến Store truyền vào)
        /// </summary>
        /// <typeparam name="T">entity</typeparam>
        /// <typeparam name="storeName">Tên store thực hiện cập nhật dữ liệu</typeparam>
        /// Người tạo: nvcuong
        /// Ngày tạo: 30/06/2015
        /// <returns>Số lượng bản ghi thêm/sửa thành công</returns>
        public int Update(T entity, string storeName)
        {
            return base.Update<T>(entity, storeName);
        }



        /// <summary>
        /// Xóa entity
        /// </summary>
        /// <param name="entity">Entity cần xóa (hàm chưa hoàn chỉnh)</param>
        /// <returns></returns>
        /// Created by: nvcuong (17/04/2017)
        public virtual int Delete()
        {
            return base.Delete(GenerateProcUtility<T>.DeleteEntityByPrimaryKey(), new object[] { });
        }


        /// <summary>
        /// Xóa dữ liệu
        /// </summary>
        /// <param name="storeName">tên store thực hiện xóa dữ liệu</param>
        /// <param name="nameParameters">mảng bao gồm TÊN các tham số truyền vào cho store (theo thứ tự trong store)</param>
        /// <param name="valueParameters">mảng bao gồm GIÁ TRỊ các tham số truyền vào cho store (theo thứ tự trong store)</param>
        /// <param name="numberParameter">số lượng tham số</param>
        /// Create by: nvcuong
        /// Create date: 30/06/2015
        /// <returns></returns>
        public override int Delete(string storeName, string[] nameParameters, object[] valueParameters, int numberParameter)
        {
            return base.Delete(storeName, nameParameters, valueParameters, numberParameter);
        }

        /// <summary>
        /// Xóa dữ liệu với nhiều tham số đầu vào
        /// </summary>
        /// <param name="sql">Tên store</param>
        /// <param name="param">Mảng các tham số truyền vào</param>
        /// <returns></returns>
        /// Created by: nvcuong (19/04/2018)
        public override int Delete(string storeName, object[] param)
        {
            return base.Delete(storeName, param);
        }
        #endregion

        #region "GetData"

        ///// <summary>
        ///// Lấy danh sách chứa toàn bộ các đối tượng
        ///// </summary>
        ///// <typeparam name="T"></typeparam>
        ///// <returns></returns>
        public IEnumerable<T> GetEntitiesAll()
        {
            string storeName = GenerateProcUtility<T>.GetEntities();
            return GetEntities(storeName);
        }

        public virtual T GetEntityById(object id)
        {
            string storeName = GenerateProcUtility<T>.GetEntityById();
            return GetEntities(storeName, (new object[] { id })).FirstOrDefault();
        }

        /// <summary>
        /// Lấy thông tin đối tượng theo ID của đối tượng
        /// </summary>
        /// <typeparam name="T">Entity</typeparam>
        /// <param name="entityId">Khóa chính của Entity</param>
        /// <returns>Entity</returns>
        /// Created by: nvcuong (20/04/2018)
        public T GetEntityByEntityId(object entityId)
        {
            string storeName = GenerateProcUtility<T>.GetEntityById();
            return GetEntities(storeName, (new object[] { entityId })).FirstOrDefault();
        }

        /// <summary>
        /// Lấy danh sách đối tượng theo tham số (test)
        /// </summary>
        /// <typeparam name="T">Đối tượng tác động</typeparam>
        /// <param name="param">Mảng các tham số</param>
        /// <returns>Danh sách dữ liệu</returns>
        /// Created by: nvcuong (20/06/2018)
        public IEnumerable<T> GetEntities_ByMultiParam(object param)
        {
            string storeName = GenerateProcUtility<T>.GetListEntity_ByMultiParam();
            return GetEntities(storeName, (new object[] { param }));
        }

        /// <summary>
        /// Lấy danh sách đối tượng theo tham số (test)
        /// </summary>
        /// <typeparam name="T">Đối tượng tác động</typeparam>
        /// <param name="param">Mảng các tham số</param>
        /// <returns>Danh sách dữ liệu được phân trang</returns>
        /// Created by: nvcuong (20/06/2018)
        public Paging<T> SelectEntitiesPaging(object[] param)
        {
            string storeName = GenerateProcUtility<T>.SelectEntitiesPaging();
            return SelectEntitiesPaging<T>(storeName, param);
        }

        #endregion

        #region "Update/Insert Data"
        public int UpdateEntity(T entity)
        {
            string storeName = GenerateProcUtility<T>.UpdateEntity();
            return Update(entity, storeName);
        }

        public int InsertEntity(T entity)
        {
            string storeName = GenerateProcUtility<T>.InsertEntity();
            return Update(entity, storeName);
        }

        /// <summary>
        /// Xóa đối tượng theo id
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="id"></param>
        /// <returns></returns>
        /// Created by: nvcuong (05/03/2018)
        public int DeleteEntityById(object id)
        {
            string storeName = GenerateProcUtility<T>.DeleteEntityByPrimaryKey();
            var entity = Activator.CreateInstance<T>();
            string tableName = entity.GetType().Name;
            return Delete(storeName, new object[] { id });
        }

        /// <summary>
        /// Xóa đối tượng theo với nhiều tham số đầu vào
        /// </summary>
        /// <typeparam name="T">entiy</typeparam>
        /// <param name="param">mảng các tham số truyền vào</param>
        /// <returns></returns>
        /// Created by: nvcuong (05/03/2018)
        public int DeleteEntity_ByMultiParam(object[] param)
        {
            string strProc = GenerateProcUtility<T>.DeleteEntityByPrimaryKey();
            var entity = Activator.CreateInstance<T>();
            string tableName = entity.GetType().Name;
            return Delete(strProc, new object[] { param });
        }
        #endregion

        //************************************************************************************



        #region OTHER
        protected virtual void InsertCommandParameters(T entity, SqlCommand cmd) { }
        protected virtual void UpdateCommandParameters(T entity, SqlCommand cmd) { }
        protected virtual void DeleteCommandParameters(T entity, SqlCommand cmd) { }
        protected virtual T Map(SqlDataReader reader) { return null; }
        protected virtual List<T> Maps(SqlDataReader reader) { return null; }


        #endregion
    }
}