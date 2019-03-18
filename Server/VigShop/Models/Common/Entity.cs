using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models.Common
{   /// <summary>
/// class abstract chứa các phương thức chung nhất của thực thẻe
/// </summary>
    public abstract class BaseEntity
    {

    }
    /// <summary>
    /// các hàm chung của 1 đối tượng thực thể
    /// </summary>
    /// <typeparam name="T">T là 1 đối tượng vd : food, menu,...</typeparam>
    public abstract class Entity<T> : BaseEntity, IEntity<T>
    {
        public virtual T Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string CreatedBy { get; set; }
    }
}