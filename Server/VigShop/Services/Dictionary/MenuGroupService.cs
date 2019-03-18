using Models.Dictionary;
using Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Repository.Base;
using Repository.Dictionary;

namespace Services.Dictionary
{
    /// <summary>
    /// tạo class triển khai các phương thức của service-> gọi đến Tầng repository để thao tác DB
    /// </summary>
    public class MenuGroupService : EntityService<MenuGroup>, IMenuGroupService
    {

        IMenuGroupRepository _menuGroupRepository;
        /// <summary>
        /// hàm khởi tạo class và đối tượng tham chiếu đến repository
        /// </summary>
        /// <param name="menuGroupRepository">dùng lại phương thức khởi tạo của class cha EntirySevice<T></param>
        public MenuGroupService(IMenuGroupRepository menuGroupRepository) : base(menuGroupRepository)
        {
            _menuGroupRepository = menuGroupRepository;
        }

        public IEnumerable<MenuGroup> CheckGroupByCode(string groupCode)
        {
            throw new NotImplementedException();
        }

        public int DeleteMenuGroups(string groupID)
        {
            return _menuGroupRepository.DeleteMenuGroups(groupID);
        }

        public IEnumerable<MenuGroup> GetGroupById(Guid? groupID)
        {
            return _menuGroupRepository.GetGroupById(groupID);
        }

        /// <summary>
        /// hàm lấy danh sách các nhóm thực đơn
        /// </summary>
        /// <returns>hàm gọi đến repository</returns>
        public IEnumerable<MenuGroup> GetGroups()
        {
            return _menuGroupRepository.GetGroups();
        }

        public int InsertGroup(MenuGroup menuGroup)
        {
            return _menuGroupRepository.Insert(menuGroup);
        }

        public int UpdateMenuGroup(MenuGroup menuGroup)
        {
            return _menuGroupRepository.UpdateMenuGroup(menuGroup);
        }
    }
}