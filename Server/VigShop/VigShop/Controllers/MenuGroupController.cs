using Models.Common;
using Models.Dictionary;
using Services.Dictionary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace VigShop.Controllers
{
    [RoutePrefix("api/group")]
    public class MenuGroupController : ApiController
    {
        /// <summary>
        /// tInject 1 thể hiện của InterFace Service vào Controller
        /// </summary>
        private readonly IMenuGroupService _menuGroupService;
        /// <summary>
        /// hàm khởi tạo contrller với tham số
        /// </summary>
        /// <param name="menuGroupService"> khởi tạo giá trị cho instance _menuGroupService</param>
        public MenuGroupController(IMenuGroupService menuGroupService)
        {
            _menuGroupService = menuGroupService;

        }
        //---------------------tạo route và các phương thức-----------------------
        /// <summary>
        /// lấy danh sách nhóm thực đơn
        /// </summary>
        /// <returns>httpResponse với bất đồng bộ(code không cần chạy tuần tự khi nhận trả về) </returns>
        [HttpGet]
        [Route("getAll")]
        public async Task<HttpResponseMessage> GetMenuGroups()
        {
            //tạo response
            HttpResponseMessage res = new HttpResponseMessage();
            //gọi đến service
            try
            {
                //gọi đến phương thức trong service
                var group = _menuGroupService.GetGroups();
                res = Request.CreateResponse(HttpStatusCode.OK, group);

            }catch(Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        [HttpGet]
        [Route("GetMenuGroupByID")]
        public async Task<HttpResponseMessage> GetMenuGroupByID(Guid? groupID)
        {
            //tạo response
            HttpResponseMessage res = new HttpResponseMessage();
            //gọi đến service
            try
            {
                //gọi đến phương thức trong service
                var group = _menuGroupService.GetGroupById(groupID);
                res = Request.CreateResponse(HttpStatusCode.OK, group);

            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        [HttpPost]
        [Route("PostMenuGroupPaging")]
        //tạo class trả về dưới dạng 1 httpResponseMessage
        public async Task<HttpResponseMessage> PostMenuGroupPaging(int currentPage, int pageSize, [FromBody] List<Filter> filters)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                ///tạo câu truy vấn theo điều kiện filter
                string where = string.Empty;
                if(filters != null && filters.Count > 0)
                {
                    where = Filter.buidWhereFilterCondition(filters);
                }
                ///tạo request gửi và lấy dữ liệu
                Paging<MenuGroup> paging = _menuGroupService.SelectEntitiesPaging(new object[] { currentPage,pageSize,where});
                res = Request.CreateResponse(HttpStatusCode.OK, paging);
                await System.Threading.Tasks.Task.Delay(1000);

            }
            catch (NullReferenceException nullReferentEx)
            {
                res = Request.CreateResponse(nullReferentEx.Message);

            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }

        [HttpPost]
        [Route("InsertGroup")]
        public async Task<HttpResponseMessage> InsertGroup(MenuGroup groupMenuFood)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                var s = _menuGroupService.InsertGroup(groupMenuFood);
                res = Request.CreateResponse(HttpStatusCode.OK, s);
            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        //sua nhom thuc don
        [HttpPut]
        [Route("updateMenuGroup")]
        public async Task<HttpResponseMessage> updateMenuGroup(MenuGroup menuGroup)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                int r = _menuGroupService.UpdateMenuGroup(menuGroup);
                res = Request.CreateResponse(HttpStatusCode.OK, r);
            }
            catch(Exception e)
            {
                res = Request.CreateResponse(e.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }

        //xóa 1 nhóm thực đơn
        [HttpDelete]
        [Route("deleteMenuGroup")]
        public async Task<HttpResponseMessage> deleteMenuGroup(string menuGroupID)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                var r = _menuGroupService.DeleteMenuGroups(menuGroupID);
                res = Request.CreateResponse(HttpStatusCode.OK, r);
            }
            catch(Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
    }
}
