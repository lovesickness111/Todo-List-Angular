using Models.Dictionary;
using Repository.Base;
using Repository.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Repository.Dictionary
{
    public class MenuGroupRepository : BaseRepository<MenuGroup>, IMenuGroupRepository
    {
        public IEnumerable<MenuGroup> CheckGroupByCode(string groupCode)
        {
            throw new NotImplementedException();
        }


        public IEnumerable<MenuGroup> GetGroupById(Guid? groupID)
        {
            string storeName = GenerateProcUtility<MenuGroup>.GetEntityById();
            return GetEntities(storeName,new object[] { groupID});
        }
        /// <summary>
        /// hàm gọi đến phương thức trong baseDL để lấy dữ liệu, truyền kèm store name
        /// </summary>
        /// <returns>hàm gọi đến baseRepository</returns>
        public IEnumerable<MenuGroup> GetGroups()
        {
            return GetEntities("dbo.Proc_GetMenuGroups");
        }

        public int InsertGroup(MenuGroup menuGroup)
        {
            throw new NotImplementedException();
        }

        public int UpdateMenuGroup(MenuGroup menuGroup)
        {
            string storeName = GenerateProcUtility<MenuGroup>.UpdateEntity();
            return Update(menuGroup, storeName);
        }
        public int DeleteMenuGroups(string groupID)
        {
            string storeName = GenerateProcUtility<MenuGroup>.DeleteEntityByPrimaryKey();
            return DeleteFood(storeName, groupID);
        }
    }
}