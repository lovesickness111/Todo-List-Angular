<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Main.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="VigShop.Views.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/Views/menu.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphFormTitle" runat="server">
    <div class="header-link-page">
        <div class="breadcrumb-parent">
            <div class="icon-breadcrumb">
                Danh mục
            </div>
        </div>
        <div class="breadcrumb-children">
            Sản phẩm
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="frmFoodList">
        <div class="toolbar">
            <div class="toolbar-body">
                <a id="btnAdd" class="toolbar-item">
                    <span class="cls-btnWrap">
                        <span class="toolbar-item-icon icon-btnFilenew"></span>
                        <span>Thêm</span>
                    </span>
                </a>
                <a id="btnDuplicate" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-btnDuplicate"></span><span class="toolbar-item-text">Nhân bản</span></span>
                </a>
                <a id="btnEdit" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="glyphicon glyphicon-edit"></span><span class="toolbar-item-text">Sửa</span></span>
                </a>
                <a id="btnDelete" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-btnDelete"></span><span class="toolbar-item-text">Xóa</span></span>
                </a>
                <a id="btnRefresh" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-refresh"></span><span class="toolbar-item-text">Nạp</span></span>
                </a>
            </div>
        </div>

        <div class="cls-gridPanel">
            <table id="table-thead">
                <thead>
                    <tr>
                        <th class="th-food-name width-200">Tên Sản Phẩm</th>
                        <th class="th-food-code width-150">Mã Sản Phẩm</th>
                        <th class="th-food-group width-150">Thuộc loại</th>
                        <th class="th-food-price width-150">Giá bán</th>
                        <th class="th-food-quantity width-150">Các cỡ giày hiện có</th>
                        <th class="th-food-notify width-150">Ghi chú</th>
                    </tr>
                    <tr>
                        <th class="th-food-name width-200">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" style="width: 100%" />
                                </div>
                            </div>
                        </th>
                        <th class="th-food-code width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-food-group width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-food-price width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-food-quantity width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-food-notify width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input type="text" />
                                </div>
                            </div>
                        </th>
                    </tr>
                </thead>
            </table>
            <table id="table-tbody">
                <tbody>
                    <%--dữ liệu đổ vào đây--%>
                </tbody>
            </table>
        </div>
    </div>

    <%--các thành phần dialog--%>
    <div id="add-new-product" title="Thêm sản phẩm mới" style="display: none">
        <div class="main-content-dialog">
            <form action="api/group/InsertGroup" method="POST">

                <div class="form-group row">
                    <label for="input-group-code" class="col-sm-3 col-form-label">Mã nhóm(*)</label>
                    <div class="col-sm-9">
                        <input type="text" required class="form-control inputGroupCode" id="input-group-code" placeholder="">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="inputGroupName" class="col-sm-3 col-form-label">Tên nhóm(*)</label>
                    <div class="col-sm-9">
                        <input type="text" required class="form-control inputGroupName" id="inputGroupName" placeholder="">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="inputGroupType" class="col-sm-3 col-form-label">Thuộc loại(*)</label>
                    <div class="col-sm-9">
                        <select required class="form-control inputGroupType" id="inputGroupType">
                            <option value="1">MÓN ĂN</option>
                            <option value="2">ĐỒ UỐNG</option>
                            <option value="3">COMBO </option>
                            <option value="4">KHÁC</option>

                        </select>
                    </div>
                </div>
                <div class="form-group row">
                    <label for="inputRestaurant" class="col-sm-3 col-form-label">Chế biến tại</label>
                    <div class="col-sm-7">
                        <select class="form-control inputGroupRestaurant" id="inputRestaurant">
                            <option value="28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d">Đại Dương Xanh</option>
                            <option value="54c0b4ce-4d2e-4f9c-a686-19a01da967ae">Thiên Thai</option>
                            <option value="4D15B7D9-64B3-4B68-8D0B-A4EB920DF12A">Thịt Chó</option>

                        </select>

                    </div>
                    <div class="col-sm-2">
                        <button class="btn btn-danger">+</button>
                    </div>
                </div>
                <div class="row form-group">
                    <label for="inputGroupDescription" class="col-sm-3 col-form-label">Diễn giải</label>
                    <textarea id="inputGroupDescription" class="col-sm-8 form-control inputGroupDescription" style="height: 40px;"></textarea>
                </div>

                <button type="submit" class="btn btn-success">Submit <span class="fa fa-arrow-right"></span></button>

            </form>
        </div>
    </div>
    <div id="edit-product" title="Basic dialog" style="display: none">
        <p>This is the default dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.</p>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="jsContent" runat="server">
    <script src="/Scripts/Views/Dictionary/menu.js"></script>
    <script>
        $(document).ready(function () {
            $('#add-new-product form').submit(function (event) {
                var MenuGroup = {
                    groupCode:$('#input-group-code').val(),
                    groupName: $('#inputGroupName').val(),
                    typeID: $('#inputGroupType').val(),
                    restaurantID: $('#inputRestaurant').val(),
                    groupDescription: $('#inputGroupDescription').val()
                };
                ///using ajax
                $.ajax({
                    url: '/api/group/InsertGroup',
                    type: "POST",
                    data: JSON.stringify(MenuGroup),
                    contentType: "application/json;charset=utf-8",
                    dataType: "JSON",
                    error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
                    success: function (data) {
                        alert("we save the world!")
                    }
                });
                event.preventDefault();
            });
        });
    </script>
</asp:Content>

