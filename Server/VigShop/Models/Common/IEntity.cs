using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models.Common
{/// <summary>
/// class model đại diện cho tất cả các thực thể
/// </summary>
/// <typeparam name="T">loại thực thể</typeparam>
    public interface IEntity<T>
    { 
        //định danh cho 1 thực thể tạm gọi là id
        T Id { get; set; }
    }
}