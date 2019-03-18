using Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using Models;
using System.Web.Http;
using Services.Dictionary;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http.Cors;

namespace VigShop.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    [RoutePrefix("api/task")]
    public class TaskController : ApiController
    {
        private readonly ITaskService _taskService;
        public TaskController(ITaskService taskService)
        {
            _taskService = taskService;
        }
        /*
         *get all
         */
        [HttpGet]
        [Route("getAll")]
        public async Task<HttpResponseMessage> GetAllTask()
        {
            //tạo response
            HttpResponseMessage res = new HttpResponseMessage();
            //gọi đến service
            try
            {
                //gọi đến phương thức trong service
                var tasks = _taskService.GetAll();
                res = Request.CreateResponse(HttpStatusCode.OK, tasks);

            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        /// <summary>
        /// thêm task
        /// </summary>
        /// <param name="task"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("add")]
        public async Task<HttpResponseMessage> InsertTask(TaskJob task)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
               int t = _taskService.Create(task);
                res = Request.CreateResponse(HttpStatusCode.OK,t);
            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        //sua task
        [HttpPut]
        [Route("update")]
        public async Task<HttpResponseMessage> updateTask(TaskJob task)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                _taskService.Update(task);
                res = Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception e)
            {
                res = Request.CreateResponse(e.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        /// <summary>
        /// update status task
        /// </summary>
        /// <param name="ID"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("status/{ID}/{status}")]
        public async Task<HttpResponseMessage> UpdateStatus(long ID, bool status)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                _taskService.ChangeStatus(status, ID);
                res = Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
        //xóa 1 nhóm thực đơn
        [HttpPost]
        [Route("delete")]
        public async Task<HttpResponseMessage> DeleteTask(TaskJob task)
        {
            HttpResponseMessage res = new HttpResponseMessage();
            try
            {
                _taskService.DeleteTask(task);
                res = Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                res = Request.CreateResponse(ex.Message);
            }
            return await System.Threading.Tasks.Task.FromResult(res);
        }
    }
}
