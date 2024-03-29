USE [master]
GO
/****** Object:  Database [cukcuk]    Script Date: 3/18/2019 10:56:43 AM ******/
CREATE DATABASE [cukcuk]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'cukcuk', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\cukcuk.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'cukcuk_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\cukcuk_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [cukcuk] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cukcuk].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [cukcuk] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cukcuk] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cukcuk] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cukcuk] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cukcuk] SET ARITHABORT OFF 
GO
ALTER DATABASE [cukcuk] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [cukcuk] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cukcuk] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cukcuk] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cukcuk] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [cukcuk] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cukcuk] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cukcuk] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cukcuk] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cukcuk] SET  DISABLE_BROKER 
GO
ALTER DATABASE [cukcuk] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cukcuk] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cukcuk] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [cukcuk] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [cukcuk] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cukcuk] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [cukcuk] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [cukcuk] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [cukcuk] SET  MULTI_USER 
GO
ALTER DATABASE [cukcuk] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [cukcuk] SET DB_CHAINING OFF 
GO
ALTER DATABASE [cukcuk] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [cukcuk] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [cukcuk] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [cukcuk] SET QUERY_STORE = OFF
GO
USE [cukcuk]
GO
/****** Object:  UserDefinedFunction [dbo].[Split_Func]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Split_Func]
(
    @RowData NVARCHAR(MAX),
    @SplitOn NVARCHAR(5)
)
RETURNS @RtnValue TABLE
(
    Id INT IDENTITY(1, 1),
    Data NVARCHAR(100)
)
AS
BEGIN
    DECLARE @Cnt INT;
    SET @Cnt = 1;

    WHILE (CHARINDEX(@SplitOn, @RowData) > 0)
    BEGIN
        INSERT INTO @RtnValue
        (
            Data
        )
        SELECT Data = LTRIM(RTRIM(SUBSTRING(@RowData, 1, CHARINDEX(@SplitOn, @RowData) - 1)));

        SET @RowData = SUBSTRING(@RowData, CHARINDEX(@SplitOn, @RowData) + 1, LEN(@RowData));
        SET @Cnt = @Cnt + 1;
    END;

    INSERT INTO @RtnValue
    (
        Data
    )
    SELECT Data = LTRIM(RTRIM(@RowData));

    RETURN;
END;
GO
/****** Object:  Table [dbo].[Class]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Class](
	[cID] [int] IDENTITY(1,1) NOT NULL,
	[cName] [nvarchar](255) NULL,
	[cStatus] [bit] NULL,
 CONSTRAINT [PK_Class] PRIMARY KEY CLUSTERED 
(
	[cID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[sID] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](255) NULL,
	[sPhone] [nvarchar](50) NULL,
	[sGender] [bit] NULL,
	[ClassID] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[sID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_student]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_student] AS
SELECT c.cID AS	'ID lớp',
       c.cName AS	'Tên lớp',
	   c.cStatus AS N'Trạng thái',
       s.sID AS 'mã sv',
	   s.sName AS	'Tên Sinh viên',											  
	   s.sGender   AS 'Giới tính',
	   s.sPhone AS 'Điện thoại'
	   FROM dbo.Class AS c
	   JOIN dbo.Student AS s
	   ON
       s.ClassID = c.cID
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [uniqueidentifier] NOT NULL,
	[CustomerCode] [nvarchar](20) NOT NULL,
	[CustomerName] [nvarchar](255) NOT NULL,
	[GroupID] [int] NULL,
	[DateOfBirth] [date] NULL,
	[CompanyName] [nvarchar](255) NULL,
	[Address] [nvarchar](255) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Email] [varchar](100) NULL,
	[MemberCard] [nvarchar](50) NULL,
	[MemberLevel] [nvarchar](50) NULL,
	[Debit] [money] NULL,
	[Note] [nvarchar](255) NULL,
	[FollowStatus] [bit] NULL,
	[User5Food] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedAt] [date] NULL,
	[ModifiedAt] [date] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupCustomer]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupCustomer](
	[GroupID] [int] NOT NULL,
	[GroupCode] [nchar](20) NOT NULL,
	[GroupName] [nvarchar](255) NOT NULL,
	[GroupParent] [nchar](20) NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedAt] [date] NULL,
	[ModifiedAt] [date] NULL,
 CONSTRAINT [PK_GroupCustomer_1] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_CustomerGroup]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_CustomerGroup]
AS
SELECT        dbo.Customer.CustomerID, dbo.Customer.CustomerCode, dbo.Customer.CustomerName, dbo.Customer.DateOfBirth, dbo.Customer.CompanyName, 
                         dbo.Customer.Address, dbo.Customer.TaxCode, dbo.Customer.PhoneNumber, dbo.Customer.Email, dbo.Customer.MemberLevel, dbo.Customer.Note, 
                         dbo.Customer.Debit, dbo.Customer.User5Food, dbo.Customer.FollowStatus, dbo.GroupCustomer.GroupID, dbo.GroupCustomer.GroupCode, 
                         dbo.GroupCustomer.GroupName, dbo.GroupCustomer.GroupParent, dbo.GroupCustomer.Description, dbo.Customer.CreatedAt, dbo.Customer.MemberCard
FROM            dbo.Customer LEFT OUTER JOIN
                         dbo.GroupCustomer ON dbo.Customer.GroupID = dbo.GroupCustomer.GroupID
GO
/****** Object:  Table [dbo].[menuGroup]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menuGroup](
	[groupID] [uniqueidentifier] NOT NULL,
	[groupCode] [nchar](50) NOT NULL,
	[groupName] [nvarchar](255) NOT NULL,
	[typeID] [int] NOT NULL,
	[groupDescription] [nchar](255) NULL,
	[groupUnfollow] [bit] NOT NULL,
	[createdBy] [nchar](50) NULL,
	[createdDate] [datetime] NULL,
	[modifiedDate] [datetime] NULL,
 CONSTRAINT [PK_menuGroup] PRIMARY KEY CLUSTERED 
(
	[groupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[restaurant]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[restaurant](
	[restaurantID] [uniqueidentifier] NOT NULL,
	[restaurantCode] [nvarchar](50) NOT NULL,
	[restaurantName] [nvarchar](100) NOT NULL,
	[createdBy] [nchar](50) NULL,
	[createdDate] [datetime] NULL,
	[modifiedDate] [datetime] NULL,
 CONSTRAINT [PK_restaurant] PRIMARY KEY CLUSTERED 
(
	[restaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[restaurants_has_menuGroup]    Script Date: 3/18/2019 10:56:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[restaurants_has_menuGroup](
	[groupID] [uniqueidentifier] NOT NULL,
	[restaurantID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_restaurants_has_menuGroup] PRIMARY KEY CLUSTERED 
(
	[groupID] ASC,
	[restaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Completed] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](255) NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[typeGroup]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[typeGroup](
	[typeID] [int] IDENTITY(1,1) NOT NULL,
	[typeCode] [nvarchar](50) NOT NULL,
	[typeName] [nvarchar](50) NOT NULL,
	[createdBy] [nchar](50) NULL,
	[createdDate] [datetime] NULL,
	[modifiedDate] [datetime] NULL,
 CONSTRAINT [PK_typeGroup] PRIMARY KEY CLUSTERED 
(
	[typeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Class] ON 

INSERT [dbo].[Class] ([cID], [cName], [cStatus]) VALUES (1, N'Cơ sở dữ liệu', 1)
INSERT [dbo].[Class] ([cID], [cName], [cStatus]) VALUES (2, N'Đại số', 0)
SET IDENTITY_INSERT [dbo].[Class] OFF
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'068878de-bedf-4267-b90e-17b2ce159a99', N'BITTET                                            ', N'bò bít tết', 1, N'thịt bò chế biến theo 3 phong cách                                                                                                                                                                                                                             ', 0, N'nvcuong                                           ', CAST(N'2018-10-24T22:48:37.377' AS DateTime), CAST(N'2018-10-24T22:48:37.377' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'0a8d6514-b0d9-4af7-89c0-1d81546d604c', N'MANHOM0001                                        ', N'thịt chó', 1, N'                                                                                                                                                                                                                                                               ', 0, N'nvcuong                                           ', CAST(N'2018-12-20T22:20:52.240' AS DateTime), CAST(N'2018-12-20T22:20:52.240' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'60c15fda-9845-430f-a3ae-22a5bee0c6ad', N'CANUOCNGOT                                        ', N'Cá nước ngọt', 1, N'cá nuôi tại ao  giá cả phải chăng                                                                                                                                                                                                                              ', 0, N'nvcuong                                           ', CAST(N'2018-10-21T17:35:22.493' AS DateTime), CAST(N'2018-10-21T17:35:22.493' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'575089ca-3937-4580-903e-574ea062946a', N'NƯỚCCAM                                           ', N'nước cam', 2, N'nước cam ép                                                                                                                                                                                                                                                    ', 0, N'nvcuong                                           ', CAST(N'2018-11-07T23:42:46.613' AS DateTime), CAST(N'2018-11-07T23:42:46.613' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'cc1d34ce-8e2e-4ba2-80e7-93ebc5254393', N'XUCXICH                                           ', N'xúc xích', 1, N'xúc xích chiên                                                                                                                                                                                                                                                 ', 0, N'nvcuong                                           ', CAST(N'2018-12-04T00:10:32.327' AS DateTime), CAST(N'2018-12-04T00:10:32.327' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'f8f51cbf-3b43-4d0d-b1fe-adf57225bc9f', N'NƯỚCCAM                                           ', N'nước cam', 2, N'nước cam ép                                                                                                                                                                                                                                                    ', 0, N'nvcuong                                           ', CAST(N'2018-11-07T23:42:46.613' AS DateTime), CAST(N'2018-11-07T23:42:46.613' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'6db32d74-21f1-4985-9bab-ae0fa48fd550', N'MANHOM1LL                                         ', N'thịt chó', 1, N'                                                                                                                                                                                                                                                               ', 0, N'nvcuong                                           ', CAST(N'2018-12-20T22:20:52.240' AS DateTime), CAST(N'2018-12-20T22:20:52.240' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'e0a15f36-7751-4a9a-a85a-c6f07fb54ae7', N'CANUOCMAN                                         ', N'Cá nước mặn', 1, N'cá nuôi tại bè                                                                                                                                                                                                                                                 ', 0, N'nvcuong                                           ', CAST(N'2018-10-21T17:36:43.803' AS DateTime), CAST(N'2018-10-21T17:36:43.803' AS DateTime))
INSERT [dbo].[menuGroup] ([groupID], [groupCode], [groupName], [typeID], [groupDescription], [groupUnfollow], [createdBy], [createdDate], [modifiedDate]) VALUES (N'ad4981b0-0a65-4c8a-9300-e8a5867cf2c1', N'thitcho                                           ', N'thịt chó', 1, N'chả cầy đủ món                                                                                                                                                                                                                                                 ', 0, N'nvcuong                                           ', CAST(N'2018-11-08T00:58:18.417' AS DateTime), CAST(N'2018-11-08T00:58:18.417' AS DateTime))
INSERT [dbo].[restaurant] ([restaurantID], [restaurantCode], [restaurantName], [createdBy], [createdDate], [modifiedDate]) VALUES (N'54c0b4ce-4d2e-4f9c-a686-19a01da967ae', N'NH002', N'THIÊN THAI', N'CẤN                                               ', NULL, NULL)
INSERT [dbo].[restaurant] ([restaurantID], [restaurantCode], [restaurantName], [createdBy], [createdDate], [modifiedDate]) VALUES (N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d', N'NH001', N'ĐẠI DƯƠNG XANH', N'NVCUONG                                           ', NULL, NULL)
INSERT [dbo].[restaurant] ([restaurantID], [restaurantCode], [restaurantName], [createdBy], [createdDate], [modifiedDate]) VALUES (N'4d15b7d9-64b3-4b68-8d0b-a4eb920df12a', N'NH003', N'THỊT CHÓ', N'HẢO                                               ', NULL, NULL)
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'068878de-bedf-4267-b90e-17b2ce159a99', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'0a8d6514-b0d9-4af7-89c0-1d81546d604c', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'60c15fda-9845-430f-a3ae-22a5bee0c6ad', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'575089ca-3937-4580-903e-574ea062946a', N'54c0b4ce-4d2e-4f9c-a686-19a01da967ae')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'cc1d34ce-8e2e-4ba2-80e7-93ebc5254393', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'f8f51cbf-3b43-4d0d-b1fe-adf57225bc9f', N'54c0b4ce-4d2e-4f9c-a686-19a01da967ae')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'6db32d74-21f1-4985-9bab-ae0fa48fd550', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'e0a15f36-7751-4a9a-a85a-c6f07fb54ae7', N'28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d')
INSERT [dbo].[restaurants_has_menuGroup] ([groupID], [restaurantID]) VALUES (N'ad4981b0-0a65-4c8a-9300-e8a5867cf2c1', N'4d15b7d9-64b3-4b68-8d0b-a4eb920df12a')
SET IDENTITY_INSERT [dbo].[Student] ON 

INSERT [dbo].[Student] ([sID], [sName], [sPhone], [sGender], [ClassID]) VALUES (2, N'Hà ', N'19001989', 1, 1)
INSERT [dbo].[Student] ([sID], [sName], [sPhone], [sGender], [ClassID]) VALUES (3, N'Thiên', N'113114115', 0, 1)
INSERT [dbo].[Student] ([sID], [sName], [sPhone], [sGender], [ClassID]) VALUES (4, N'Cường đẹp trai', N' 669899', 1, 2)
INSERT [dbo].[Student] ([sID], [sName], [sPhone], [sGender], [ClassID]) VALUES (5, N'cuóng', N'22', 1, 1)
SET IDENTITY_INSERT [dbo].[Student] OFF
SET IDENTITY_INSERT [dbo].[Task] ON 

INSERT [dbo].[Task] ([Id], [Title], [Completed], [CreatedDate], [ModifiedDate], [CreatedBy]) VALUES (46, N'CRUD ', 0, CAST(N'2019-02-28T21:43:32.643' AS DateTime), CAST(N'2019-03-18T10:29:31.090' AS DateTime), N'nvcuong')
INSERT [dbo].[Task] ([Id], [Title], [Completed], [CreatedDate], [ModifiedDate], [CreatedBy]) VALUES (52, N'lập team làm app tại nhà', 0, CAST(N'2019-02-28T22:12:25.233' AS DateTime), CAST(N'2019-02-28T23:13:50.790' AS DateTime), N'nvcuong')
INSERT [dbo].[Task] ([Id], [Title], [Completed], [CreatedDate], [ModifiedDate], [CreatedBy]) VALUES (54, N'viết các hàm xử lý nếu thành lấy dl thành công', 0, CAST(N'2019-03-18T10:34:53.250' AS DateTime), CAST(N'2019-03-18T10:34:53.250' AS DateTime), N'nvcuong')
SET IDENTITY_INSERT [dbo].[Task] OFF
SET IDENTITY_INSERT [dbo].[typeGroup] ON 

INSERT [dbo].[typeGroup] ([typeID], [typeCode], [typeName], [createdBy], [createdDate], [modifiedDate]) VALUES (1, N'MONAN', N'MÓN ĂN', N'NVCUONG                                           ', NULL, NULL)
INSERT [dbo].[typeGroup] ([typeID], [typeCode], [typeName], [createdBy], [createdDate], [modifiedDate]) VALUES (2, N'DOUONG', N'ĐỒ UỐNG', N'NVCUONG                                           ', NULL, NULL)
INSERT [dbo].[typeGroup] ([typeID], [typeCode], [typeName], [createdBy], [createdDate], [modifiedDate]) VALUES (3, N'COMBO', N'COMBO', N'NVCUONG                                           ', NULL, NULL)
SET IDENTITY_INSERT [dbo].[typeGroup] OFF
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_CustomerID]  DEFAULT (newid()) FOR [CustomerID]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_FollowStatus]  DEFAULT ((1)) FOR [FollowStatus]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_User5Food]  DEFAULT ((0)) FOR [User5Food]
GO
ALTER TABLE [dbo].[menuGroup] ADD  CONSTRAINT [DF_menuGroup_groupID]  DEFAULT (newid()) FOR [groupID]
GO
ALTER TABLE [dbo].[menuGroup] ADD  CONSTRAINT [DF_menuGroup_groupUnfollow]  DEFAULT ((0)) FOR [groupUnfollow]
GO
ALTER TABLE [dbo].[restaurant] ADD  CONSTRAINT [DF_restaurant_restaurantID]  DEFAULT (newid()) FOR [restaurantID]
GO
ALTER TABLE [dbo].[restaurants_has_menuGroup] ADD  CONSTRAINT [DF_restaurants_has_menuGroup_groupID]  DEFAULT (newid()) FOR [groupID]
GO
ALTER TABLE [dbo].[Task] ADD  CONSTRAINT [DF_Task_completed]  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[Task] ADD  CONSTRAINT [DF_Task_createdBy]  DEFAULT (N'nvcuong') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[menuGroup]  WITH CHECK ADD  CONSTRAINT [FK_menuGroup_typeGroup] FOREIGN KEY([typeID])
REFERENCES [dbo].[typeGroup] ([typeID])
GO
ALTER TABLE [dbo].[menuGroup] CHECK CONSTRAINT [FK_menuGroup_typeGroup]
GO
ALTER TABLE [dbo].[restaurants_has_menuGroup]  WITH CHECK ADD  CONSTRAINT [FK_restaurants_has_menuGroup_menuGroup] FOREIGN KEY([groupID])
REFERENCES [dbo].[menuGroup] ([groupID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[restaurants_has_menuGroup] CHECK CONSTRAINT [FK_restaurants_has_menuGroup_menuGroup]
GO
ALTER TABLE [dbo].[restaurants_has_menuGroup]  WITH CHECK ADD  CONSTRAINT [FK_restaurants_has_menuGroup_restaurant] FOREIGN KEY([restaurantID])
REFERENCES [dbo].[restaurant] ([restaurantID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[restaurants_has_menuGroup] CHECK CONSTRAINT [FK_restaurants_has_menuGroup_restaurant]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Class] FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([cID])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Class]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckUniqueCustomerCode]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 20/11/2018
-- Description:	Thủ tục check trùng mã khách hàng
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckUniqueCustomerCode] 
	-- Add the parameters for the stored procedure here
	@CustomerCode VARCHAR(255)
	--@Result BIT OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT COUNT(*) FROM dbo.Customer WHERE CustomerCode = @CustomerCode
	
	RETURN @@ROWCOUNT 
	--SET @Result = 0
	--IF @@ROWCOUNT > 0 
	--SET @Result = 1
	--RETURN @Result

    -- Insert statements for procedure here
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_CreateCustomer]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 19/10/18
-- Description:	Thủ tục thêm một khách hàng mới
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CreateCustomer] 
	-- Add the parameters for the stored procedure here
	@CustomerCode VARCHAR(20),
	@CustomerName NVARCHAR(225),
	@PhoneNumber VARCHAR(50),
	@DateOfBirth DATE,
	@CompanyName NVARCHAR(255),
	@TaxCode VARCHAR(50),
	@MemberCard VARCHAR(50),
	@MemberLevel NVARCHAR(255),
	@FollowStatus VARCHAR(20),
	@Email VARCHAR(255),
	@Address NVARCHAR(255),
	@Note NVARCHAR(255),
	@Debit MONEY,
	@User5Food VARCHAR(20),
	@GroupID INT,
	@CreatedAt DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustomerID UNIQUEIDENTIFIER
	SET @CustomerID = NEWID()
	
	IF @GroupID = 0
		SET @GroupID = NULL

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Customer] 
	( 
		CustomerID,
		CustomerCode,
		CustomerName,
		PhoneNumber,
		DateOfBirth,
		CompanyName,
		TaxCode,
		MemberCard,
		MemberLevel,
		FollowStatus,
		Email,
		Address,
		Note,
		Debit,
		User5Food,
		GroupID,
		CreatedAt	
	)
	VALUES(
	@CustomerID,
	@CustomerCode,
	@CustomerName,
	@PhoneNumber,
	@DateOfBirth,
	@CompanyName,
	@TaxCode,
	@MemberCard,
	@MemberLevel,
	@FollowStatus,
	@Email,
	@Address,
	@Note,
	@Debit,
	@User5Food,
	@GroupID,
	@CreatedAt
	)

END
GO
/****** Object:  StoredProcedure [dbo].[Proc_CreateGroupCustomer]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 25/10/18
-- Description:	Thủ tục thêm nhóm khách hàng mới
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CreateGroupCustomer] 
	-- Add the parameters for the stored procedure here
	@GroupCode NVARCHAR(255), 
	@GroupName NVARCHAR(MAX), 
	@Description NVARCHAR(MAX),
	@GroupParent int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @MAX_GROUP_ID INT
	SET @MAX_GROUP_ID = (SELECT TOP 1 GroupID FROM dbo.GroupCustomer ORDER BY GroupID DESC) + 1

	IF @GroupParent = 0
		SET @GroupParent = NULL

	INSERT INTO dbo.GroupCustomer
	(
	    GroupID,
	    GroupCode,
	    GroupName,
	    GroupParent,
	    Description,
	    CreatedBy,
	    CreatedAt,
	    ModifiedAt
	)
	VALUES
	(   
		@MAX_GROUP_ID,			-- GroupID - int
	    @GroupCode,			-- GroupCode - nchar(20)
	    @GroupName,			-- GroupName - nvarchar(255)
	    @GroupParent,       -- GroupParent - nchar(20)
	    @Description,       -- Description - nvarchar(255)
	    N'NADUNG',			-- CreatedBy - nvarchar(50)
	    GETDATE(),			-- CreatedAt - date
	    GETDATE()			-- ModifiedAt - date
	    )
    -- Insert statements for procedure here

END
GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteCustomer]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 25/10/2018
-- Description:	Thủ tục xóa khách hàng
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteCustomer] 
	-- Add the parameters for the stored procedure here
	@ListID NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX)
		
    -- Insert statements for procedure here 
	SET @SQL = 'DELETE FROM dbo.Customer WHERE CustomerID IN ' + @ListID
	EXECUTE(@SQL)
END





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeletemenuGroupByID]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NTQuyen
-- Create date: 12/10/2018
-- Description:	Xóa dữ liệu bảng thực đơn
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeletemenuGroupByID] 
@groupID NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT on;
	DELETE FROM dbo.menuGroup
    WHERE groupID=@groupID;
END;

GO
/****** Object:  StoredProcedure [dbo].[Proc_DeletemenuGroups]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,cuong>
-- Create date: <Create Date,,>
-- Description:	<Description,,store delete multi rows>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeletemenuGroups] 
	-- Add the parameters for the stored procedure here
	@GroupMenuIDs NVARCHAR(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT on;

    -- Insert statements for procedure here
	DELETE FROM dbo.menuGroup
	WHERE groupID IN(SELECT data FROM dbo.Split_Func(@GroupMenuIDs,','));
	DELETE FROM dbo.restaurants_has_menuGroup
	WHERE groupID IN(SELECT data FROM dbo.Split_Func(@GroupMenuIDs,','));
END;
GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteTaskJobByID]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteTaskJobByID]
	-- Add the parameters for the stored procedure here
@Id	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  DELETE FROM dbo.Task WHERE Id = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_EditCustomer]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 15/10/18
-- Description:	Thủ tục sửa một bản ghi
-- =============================================
CREATE PROCEDURE [dbo].[Proc_EditCustomer] 
	-- Add the parameters for the stored procedure here
	@CustomerID UNIQUEIDENTIFIER,
	@CustomerCode VARCHAR(20),
	@CustomerName NVARCHAR(225),
	@PhoneNumber VARCHAR(50),
	@DateOfBirth DATE,
	@CompanyName NVARCHAR(255),
	@TaxCode VARCHAR(50),
	@MemberCard VARCHAR(50),
	@MemberLevel NVARCHAR(255),
	@FollowStatus VARCHAR(20),
	@Email VARCHAR(255),
	@Address NVARCHAR(255),
	@Note NVARCHAR(255),
	@Debit MONEY,
	@User5Food VARCHAR(20),
	@GroupID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @GroupID = 0
	SET @GroupID = NULL
    -- Insert statements for procedure here
	UPDATE dbo.Customer 
	SET CustomerCode = @CustomerCode,
		CustomerName = @CustomerName,
		PhoneNumber = @PhoneNumber,
		DateOfBirth = @DateOfBirth,
		CompanyName = @CompanyName,
		TaxCode = @TaxCode,
		MemberCard = @MemberCard,
		MemberLevel = @MemberLevel,
		FollowStatus =@FollowStatus,
		Email = @Email,
		Address= @Address,
		Note = @Note,
		Debit= @Debit,
		User5Food= @User5Food,
		GroupID = @GroupID
	WHERE CustomerID = @CustomerID 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCustomerById]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 13/10/2018
-- Description:	Thủ tục cho việc sửa khách hàng
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetCustomerById]
	-- Add the parameters for the stored procedure here
	@CustomerID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
			VC.CustomerID,
			VC.CustomerCode,
			VC.CustomerName,
			VC.PhoneNumber,
			VC.DateOfBirth,
			VC.CompanyName,
			VC.TaxCode,
			VC.MemberCard,
			VC.MemberLevel,
			VC.FollowStatus,
			VC.Email,
			VC.Address,
			VC.Note,
			VC.Debit,
			VC.User5Food,
			VC.GroupID, 
			VC.GroupCode,
			VC.GroupName,
			VC.GroupParent,
			VC.Description
		   FROM dbo.View_CustomerGroup AS VC WHERE VC.CustomerID = @CustomerID
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCustomerPaging]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 09/10/18
-- Description:	Lấy danh sách khách hàng 
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetCustomerPaging] 
	-- Add the parameters for the stored procedure here
	@CurrentPage INT, 
	@PageSize INT,
	@Where NVARCHAR(MAX),
	@TotalPage INT OUTPUT,
	@TotalRecord INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX)

	-- Set đầu cuối
	DECLARE @startIndex INT = (@CurrentPage - 1) * @PageSize + 1;
	DECLARE @endIndex INT = @startIndex + @PageSize-1;


	-- Lấy tất cả khách hàng
	SET @SQL = 'SELECT 
			ROW_NUMBER() OVER (ORDER BY CreatedAt DESC) AS RowNumber,
			VC.CustomerID,
           VC.CustomerCode,
           VC.CustomerName,
           VC.PhoneNumber,
           CONVERT(VARCHAR(20),VC.DateOfBirth) AS Birthday,
           VC.CompanyName,
           VC.TaxCode,
           VC.MemberCard,
           VC.MemberLevel,
           VC.FollowStatus,
           VC.Email,
           VC.Address,
           VC.Note,
		   CONVERT(VARCHAR(10),VC.Debit) AS Debit,
           VC.User5Food,
           VC.GroupID, 
		   VC.GroupCode,
		   VC.GroupName,
		   VC.GroupParent,
		   VC.Description,
		   VC.CreatedAt
		   INTO #tblCustomer
	FROM dbo.View_CustomerGroup AS VC WHERE ' + @Where + ' ORDER BY CreatedAt DESC;
	
	SET @TotalRecord= (SELECT COUNT(*) FROM #tblCustomer);

	SELECT * 
		FROM #tblCustomer AS TC 
		WHERE TC.RowNumber BETWEEN  @startIndex AND @endIndex;'
		
	EXEC sp_executesql @sql,
		N'@startIndex INT, @endIndex INT, @TotalRecord INT OUTPUT',
		@startIndex, @endIndex, @TotalRecord OUTPUT;
	
	IF(@TotalRecord % @PageSize = 0)
	SET @TotalPage = (@TotalRecord / @PageSize) 
	IF(@TotalRecord % @PageSize <> 0)
	SET @TotalPage = (@TotalRecord / @PageSize) + 1
	-- Lấy tổng số bản ghi
	-- Tổng số bản ghi

END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupCustomer]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NADUNG
-- Create date: 15/10/18
-- Description:	Thủ tục lấy danh sách nhóm khách hàng
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetGroupCustomer] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT	GC.GroupID,
			GC.GroupCode,
			GC.GroupName,
			GC.Description,
			GC.GroupParent
	 FROM dbo.GroupCustomer AS GC
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetmenuGroupById]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetmenuGroupById]
	-- Add the parameters for the stored procedure here
@groupID UNIQUEIDENTIFIER
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ROW_NUMBER()OVER(ORDER BY m.groupCode) AS SortGroup,
	m.groupID,
	m.groupCode,
	m.groupName,
	t.typeID,
	t.typeName,
	rm.restaurantID,
	rm.restaurantName,
	m.groupDescription,
	m.groupUnfollow,
	m.createdBy,
	m.createdDate,
	m.modifiedDate
	FROM dbo.menuGroup AS m 
	LEFT JOIN dbo.typeGroup AS t
	ON t.typeID = m.typeID
	LEFT JOIN (Select rhm.groupID,
	 rhm.restaurantID,
	  r.restaurantCode,
	  r.restaurantName 
	  FROM dbo.restaurants_has_menuGroup as rhm 
	  LEFT Join dbo.restaurant as r 
	  ON rhm.restaurantID = r.restaurantID) AS rm
	ON rm.groupID = @groupID
	WHERE m.groupID = @groupID;
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetMenuGroups]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,cuong>
-- Create date: <Create Date,,18/10/2018>
-- Description:	<Description,,lay danh sach nhóm thực đơn>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetMenuGroups]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.groupID,m.groupCode,m.groupName,m.typeID,m.groupDescription,m.groupUnfollow,m.createdBy,m.createdDate,m.modifiedDate FROM dbo.menuGroup AS m;
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTaskJobs]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetTaskJobs]
	-- Add the parameters for the stored procedure here
AS
BEGIN

	SET NOCOUNT ON;
	SELECT * FROM dbo.Task ORDER BY modifiedDate
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertmenuGroup]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		nvcuong
-- Create date: 15/10/2018
-- Description:	Thêm dữ liệu vào bảng nhóm thực đơn
-- =============================================
CREATE PROCEDURE [dbo].[Proc_InsertmenuGroup]
    @groupCode NVARCHAR(20),
    @groupName NVARCHAR(255),
    @groupDescription NVARCHAR(255),
    @groupUnfollow BIT,
    @typeID INT,
	@restaurantID UNIQUEIDENTIFIER
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT on;
	DECLARE @groupID UNIQUEIDENTIFIER=NEWID();
    INSERT INTO dbo.menuGroup
    (	groupID,
        groupCode,
        groupName,
        typeID,
        groupDescription,
        groupUnfollow,
        createdBy,
        createdDate,
        modifiedDate
    )
    VALUES
    (@groupID,@groupCode, @groupName, @typeID, @groupDescription, @groupUnfollow,N'nvcuong',GETDATE(),GETDATE());
	---update theo group id bang restaurant_has_menuGroup
	INSERT INTO dbo.restaurants_has_menuGroup
	(groupID,
	restaurantID
	)
	VALUES(@groupID,@restaurantID)
	
END;
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertStudent]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertStudent]
@name NVARCHAR(max),
@phone NVARCHAR(25),
@gender BIT,
@classID INT
AS
BEGIN
INSERT INTO dbo.Student
(
    sName,
    sPhone,
    sGender,
    ClassID
)
VALUES
(   @name,  -- sName - nvarchar(255)
    @phone,  -- sPhone - nvarchar(50)
    @gender, -- sGender - bit
    @classID     -- ClassID - int
    )
    
END;
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertTaskJob]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_InsertTaskJob]
	-- Add the parameters for the stored procedure here
@Title NVARCHAR(max),
@Completed BIT
AS
BEGIN

	SET NOCOUNT ON;
	INSERT INTO dbo.Task
	(
	    Title,
	    Completed,
		CreatedDate,
		ModifiedDate
	)
	VALUES
	(   @Title, -- title - nvarchar(max)
	    @Completed,
		GETDATE(),
		GETDATE()
	    )
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectMaleStudent]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectMaleStudent]
@Number INT 
AS
BEGIN
SELECT COUNT(1) AS male_count,s.ClassID
INTO #maleCount
FROM dbo.Student AS s WHERE s.sGender = 1 GROUP BY s.ClassID ;

   SELECT DISTINCT c.cID,c.cName,c.cStatus
    FROM dbo.Class AS c
	LEFT JOIN
	#maleCount AS m
	ON m.ClassID = c.cID
	WHERE male_count >= @Number	;
END;
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectmenuGroupsPaging]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectmenuGroupsPaging]
	-- Add the parameters for the stored procedure here
	@CurrentPage INT,
	@PageSize INT,
	@Where NVARCHAR(MAX),
	@TotalRecord INT OUTPUT,
	@TotalPage INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--xem xet lay tu ban ghi bao nhieu
	DECLARE @startIndex INT = (@CurrentPage - 1) * @PageSize + 1;
	DECLARE @endIndex INT = @startIndex + @PageSize-1;
	--tao cau query de gan cau where
	--params: @total = bien output
	
	  
	DECLARE @sql NVARCHAR(MAX) = N'
	SELECT ROW_NUMBER()OVER(ORDER BY m.groupCode) AS SortGroup,
	m.groupID,
	m.groupCode,
	m.groupName,
	t.typeID,
	t.typeName,
	rm.restaurantID,
	rm.restaurantName,
	m.groupDescription,
	m.groupUnfollow,
	m.createdDate,
	m.createdBy,
	m.modifiedDate
	INTO #tblListMenu
	FROM dbo.menuGroup AS m 
	LEFT JOIN dbo.typeGroup AS t
	ON t.typeID = m.typeID
	LEFT JOIN (Select rhm.groupID, rhm.restaurantID, r.restaurantCode,r.restaurantName from dbo.restaurants_has_menuGroup as rhm left Join dbo.restaurant as r on rhm.restaurantID = r.restaurantID) AS rm
	ON rm.groupID = m.groupID
	WHERE 1=1 [@WhereCondition]
	
	SELECT @total = MAX(TC.SortGroup) FROM #tblListMenu AS TC
	SELECT * FROM #tblListMenu AS CurrentRecord
	WHERE CurrentRecord.SortGroup BETWEEN @startIndex AND @endIndex 
	Order BY CreatedDate DESC, ModifiedDate DESC;
	';
	SET @sql = REPLACE(@sql,'[@WhereCondition]',@Where)
	--executing sq


	EXEC sp_executesql @sql = @sql,
						@params = N'@startIndex INT,@endIndex INT,@total INT OUTPUT',
						@startIndex=@startIndex,
						@endIndex=@endIndex,
						@total = @TotalRecord OUTPUT;

  -- Tổng số trang:							
	SET @TotalPage = ISNULL(@TotalRecord,0)/@PageSize + 
				CASE WHEN @TotalRecord%@PageSize = 0 THEN 0 
					 ELSE (CASE WHEN @TotalRecord IS NULL THEN 0 ELSE 1 END) 
				END
 
	----Tổng số bản ghi:
	SET @TotalRecord = ISNULL(@TotalRecord,0)

    -- Insert statements for procedure here
	--SELECT t.typeName,m.groupCode,m.groupName,m.groupDescription,m.groupUnfollow,m.createdDate,m.createdBy,m.modifiedDate
	--FROM dbo.menuGroup AS m
	--LEFT JOIN dbo.typeGroup AS t
	--ON t.typeID = m.typeID
	--LEFT JOIN dbo.restaurants_has_menuGroup AS rm
	--ON rm.groupID = m.groupID
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdatemenuGroup]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_UpdatemenuGroup]
	-- Add the parameters for the stored procedure here
	@groupID UNIQUEIDENTIFIER,
	@groupCode NVARCHAR(20),
    @groupName NVARCHAR(255),
    @typeID INT,
	@restaurantID UNIQUEIDENTIFIER,
    @groupDescription NVARCHAR(255),
    @groupUnfollow BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE dbo.menuGroup
	SET groupCode=@groupCode,
		groupName=@groupName,
		typeID=@typeID,
		groupDescription=@groupDescription,
		groupUnfollow=@groupUnfollow
	WHERE groupID =@groupID
	UPDATE dbo.restaurants_has_menuGroup
	SET restaurantID=@restaurantID
	WHERE groupID =@groupID
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateTaskJob]    Script Date: 3/18/2019 10:56:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_UpdateTaskJob]
	-- Add the parameters for the stored procedure here
@Id BIGINT,
@Title NVARCHAR(max),
@Completed BIT
AS
BEGIN

	SET NOCOUNT ON;
	UPDATE dbo.Task SET 
    Title = @Title,
	Completed = @Completed ,
	ModifiedDate = GETDATE()
	WHERE Id = @Id
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Khoá chính' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CustomerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã khách hàng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CustomerCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên khách hàng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CustomerName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Khóa chính của bảng nhóm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'GroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sinh' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'DateOfBirth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên công ty' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CompanyName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã số thuế' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'TaxCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SĐT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã thẻ thành viên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'MemberCard'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hạng thẻ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'MemberLevel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Số tiền nợ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Debit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ghi chú' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngừng theo dõi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'FollowStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Thành viên 5Food không?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'User5Food'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tạo bởi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CreatedAt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'ModifiedAt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'GroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã nhóm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'GroupCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên nhóm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'GroupName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Thuộc nhóm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'GroupParent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Diễn giải' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tạo bởi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'CreatedAt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GroupCustomer', @level2type=N'COLUMN',@level2name=N'ModifiedAt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'luyện tập tại nhà' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'menuGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Customer"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "GroupCustomer"
            Begin Extent = 
               Top = 6
               Left = 249
               Bottom = 135
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_CustomerGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_CustomerGroup'
GO
USE [master]
GO
ALTER DATABASE [cukcuk] SET  READ_WRITE 
GO
