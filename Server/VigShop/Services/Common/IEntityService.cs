using Models.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Common
{
    /// <summary>
    /// tạo interface service các hàm dùng chung với kiểu T là 1 thực thể
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IEntityService<T>:IService where T:BaseEntity

    {
        int Create(T entity);
        void Delete(T entity);
        IEnumerable<T> GetAll();
        T GetEntityById(object id);
        void Update(T entity);
        Paging<T> SelectEntitiesPaging(object[] param);
    }
}
