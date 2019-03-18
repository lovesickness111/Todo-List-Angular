using Models.Dictionary;
using Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Dictionary
{
   public interface IMenuGroupService:IEntityService<MenuGroup>
    {
        /// <summary>
        /// lấy các nhóm (nhiều)
        /// </summary>
        /// <returns>1 mảng dữ liệu </returns>
        IEnumerable<MenuGroup> GetGroups();
        //lấy theo Id
        IEnumerable<MenuGroup> GetGroupById(Guid? groupID);
        //lấy theo mã
        IEnumerable<MenuGroup> CheckGroupByCode(string groupCode);
        /// <summary>
        /// thao tác thêm , sửa, xóa
        /// </summary>
        /// <param name="menuGroup"> đối tượng thao tác</param>
        /// <returns></returns>
        int InsertGroup(MenuGroup menuGroup);
        int UpdateMenuGroup(MenuGroup menuGroup);
        /// <summary>
        /// xóa nhiều 
        /// </summary>
        /// <param name="groupID">chuổi chứa các id cần xóa</param>
        /// <returns></returns>
        int DeleteMenuGroups(string groupID);
    }
}
