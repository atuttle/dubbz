USE [dubbz]
GO
/****** Object:  Table [dbo].[tblStream]    Script Date: 01/27/2012 20:19:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStream](
	[streamId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[streamTitle] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_tblStream] PRIMARY KEY CLUSTERED 
(
	[streamId] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


USE [dubbz]
GO
/****** Object:  Table [dbo].[tblStreamEvent]    Script Date: 01/27/2012 20:20:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStreamEvent](
	[eventId] [bigint] IDENTITY(1,1) NOT NULL,
	[streamId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[eventTimestamp] [datetime] NOT NULL CONSTRAINT [DF_tblStreamEvent_eventTimestamp]  DEFAULT (getdate()),
	[diceSize] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rollValue] [int] NULL,
	[rollGroup] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chatText] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chatHandle] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_tblStreamEvent] PRIMARY KEY CLUSTERED 
(
	[eventId] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblStreamEvent]  WITH CHECK ADD  CONSTRAINT [FK_tblStreamEvent_tblStream] FOREIGN KEY([streamId])
REFERENCES [dbo].[tblStream] ([streamId])
GO
ALTER TABLE [dbo].[tblStreamEvent] CHECK CONSTRAINT [FK_tblStreamEvent_tblStream]