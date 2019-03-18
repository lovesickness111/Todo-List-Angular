using Models.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Repository.Base
{
    /// <summary>
    /// interface định danh các phương thức sẽ được triển khai trong base
    /// </summary>
    public interface IBaseRepository<T> where T:class
    {   /// <summary>
    /// sử lý lấy dữ liệu từ procedure với tham số truyền vào
    /// </summary>
    /// <param name="storeName">tên stored procedure</param>
    /// <param name="param">danh sách tham số được truyền vào dạng mảng object</param>
    /// <returns></returns>
        int ExecuteNonQuery(string storeName, object[] param);
        /// <summary>
        /// thêm 1 đối tượng    
        /// </summary>
        /// <param name="entity"> thực thể kiểu T</param>
        /// <returns></returns>
        int Insert(T entity);
        int Update(T entity);
        int Delete();
        IEnumerable<T> GetEntitiesAll();
        IEnumerable<T> GetEntities(string strProc);
        IEnumerable<T> GetEntities(string storeName, object[] value);
        IEnumerable<T> GetEntitiesPaging(string storeName, string sqlTotal, int start, int limit, out int total);
        Paging<T> SelectEntitiesPaging(object[] param);
        T GetEntityById(object id);
        int Update(T Object, string sql);
        int Delete(string storeName, string[] name, object[] value, int Nparameter);
        int Delete(string storeName,object[] value);
    }
}