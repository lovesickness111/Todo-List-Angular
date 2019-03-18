using Models.Common;
using Repository.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Services.Common
{
    /// <summary>
    /// Abstract class Entity dùng chung
    /// </summary>
    /// <typeparam name="T">Entity</typeparam>
    /// Created by: nvcuong (12/04/2018)
    public abstract class EntityService<T> : IEntityService<T> where T : BaseEntity
    {
        //IUnitOfWork _unitOfWork;
        IBaseRepository<T> _repository;

        /// <summary>
        /// Khởi tạo Entity Service
        /// </summary>
        /// <param name="unitOfWork"></param>
        /// <param name="repository"></param>
        /// Created by: nvcuong (12/04/2018) 
        public EntityService(IBaseRepository<T> repository)
        {
            //_unitOfWork = unitOfWork;
            _repository = repository;
        }


        /// <summary>
        /// Thêm mới
        /// </summary>
        /// <param name="entity">Entity truyền vào</param>
        /// Created by: nvcuong
        public virtual int Create(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity is null");
            return _repository.Insert(entity);
            //_unitOfWork.Commit();
        }

        /// <summary>
        /// Sửa Entity
        /// </summary>
        /// <param name="entity">Entity truyền vào</param>
        /// Created by: nvcuong
        public virtual void Update(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity is null");
            _repository.Update(entity);

        }

        /// <summary>
        /// Xóa Entity
        /// </summary>
        /// <param name="entity">Entity truyền vào</param>
        /// Created by: nvcuong
        public virtual void Delete(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity is null");
            _repository.Delete();
            //_unitOfWork.Commit();
        }

        /// <summary>
        /// Lấy dữ liệu
        /// </summary>
        /// <returns> trả về 1 mảng read only và duyệt từ đầu đến cuối mảng</returns>
        /// Created by: nvcuong
        public virtual IEnumerable<T> GetAll()
        {
            return _repository.GetEntitiesAll();
        }

        public T GetEntityById(object id)
        {
            return _repository.GetEntityById(id);
        }

        public override string ToString()
        {
            return base.ToString();
        }

        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public Paging<T> SelectEntitiesPaging(object[] param)
        {
            return _repository.SelectEntitiesPaging(param);
        }
    }
}