USE [master]
GO
/****** Object:  Database [AdminDB]    Script Date: 16.01.2018 20:56:29 ******/
CREATE DATABASE [AdminDB]
GO

USE [AdminDB]
GO
/****** Object:  Schema [CONFIG]    Script Date: 16.01.2018 20:56:30 ******/
CREATE SCHEMA [CONFIG]
GO
/****** Object:  Table [CONFIG].[tblDatabaseBackupDiff]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONFIG].[tblDatabaseBackupDiff](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Parameter] [nvarchar](256) NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ValueDataType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ScriptRelease] [date] NULL,
 CONSTRAINT [PK_tblConfig_BackupDiff] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CONFIG].[tblDatabaseBackupFull]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONFIG].[tblDatabaseBackupFull](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Parameter] [nvarchar](256) NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ValueDataType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ScriptRelease] [date] NULL,
 CONSTRAINT [PK_tblConfig_Backup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CONFIG].[tblDatabaseBackupLog]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONFIG].[tblDatabaseBackupLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Parameter] [nvarchar](256) NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ValueDataType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ScriptRelease] [date] NULL,
 CONSTRAINT [PK_tblConfig_BackupLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CONFIG].[tblDatabaseIntegrityCheck]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONFIG].[tblDatabaseIntegrityCheck](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Parameter] [nvarchar](256) NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ValueDataType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ScriptRelease] [date] NULL,
 CONSTRAINT [PK_tblConfig_CheckDB] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [CONFIG].[tblIndexOptimize]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONFIG].[tblIndexOptimize](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Parameter] [nvarchar](256) NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ValueDataType] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ScriptRelease] [date] NULL,
 CONSTRAINT [PK_tblConfigIndexOptimize] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BackupJobs]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupJobs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[RunDate] [datetime] NOT NULL,
	[JobName] [nvarchar](128) NOT NULL,
	[CreateJobStatement] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BackupLogins]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupLogins](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[RunDate] [datetime] NOT NULL,
	[CreateLoginStatement] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_BackupLogins] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommandLog]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommandLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] NULL,
	[SchemaName] [sysname] NULL,
	[ObjectName] [sysname] NULL,
	[ObjectType] [char](2) NULL,
	[IndexName] [sysname] NULL,
	[IndexType] [tinyint] NULL,
	[StatisticsName] [sysname] NULL,
	[PartitionNumber] [int] NULL,
	[ExtendedInfo] [xml] NULL,
	[Command] [nvarchar](max) NOT NULL,
	[CommandType] [nvarchar](60) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ErrorNumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupDiff] ON 
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (1, N'@Databases', N'ALL_DATABASES', N'NVARCHAR(MAX)', N'Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (2, N'@Directory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (3, N'@BackupType', N'DIFF', N'NVARCHAR(MAX)', N'Specify the type of backup: full, differential, or transaction log.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (4, N'@Verify', N'N', N'NVARCHAR(MAX)', N'Verify the backup', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (7, N'@CleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted. If no time is specified, then no backup files are deleted.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (8, N'@CleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (9, N'@Compress', N'[NULL]', N'NVARCHAR(MAX)', N'Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (10, N'@CopyOnly', N'N', N'NVARCHAR(MAX)', N'Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (11, N'@ChangeBackupType', N'Y', N'NVARCHAR(MAX)', N'Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead.

DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (12, N'@BackupSoftware', N'[NULL]', N'NVARCHAR(MAX)', N'Specify third-party backup software; otherwise, SQL Server native backup is performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (13, N'@CheckSum', N'N', N'NVARCHAR(MAX)', N'Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (14, N'@BlockSize', N'[NULL]', N'INT', N'Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (15, N'@BufferCount', N'[NULL]', N'INT', N'Specify the number of I/O buffers to be used for the backup operation.

The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (16, N'@MaxTransferSize', N'[NULL]', N'INT', N'Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media.

The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (17, N'@NumberOfFiles', N'[NULL]', N'INT', N'Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (18, N'@CompressionLevel', N'[NULL]', N'INT', N'Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level.

In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (19, N'@Description', N'[NULL]', N'NVARCHAR(MAX)', N'Enter a description for the backup.

The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (20, N'@Threads', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (21, N'@Throttle', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (22, N'@Encrypt', N'N', N'NVARCHAR(MAX)', N'Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (23, N'@EncryptionAlgorithm', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the type of encryption. The EncryptionAlgorithm option in DatabaseBackup uses the ENCRYPTION and ALGORITHM options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (24, N'@ServerCertificate', N'[NULL]', N'NVARCHAR(MAX)', N'Server certificate that is used to encrypt the backup.

The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (25, N'@ServerAsymmetricKey', N'[NULL]', N'NVARCHAR(MAX)', N'Asymmetric key that is used to encrypt the backup.

The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (26, N'@EncryptionKey', N'[NULL]', N'NVARCHAR(MAX)', N'Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. ', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (27, N'@ReadWriteFileGroups', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the primary filegroup and any read/write filegroups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (28, N'@OverrideBackupPreference', N'N', N'NVARCHAR(MAX)', N'Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (29, N'@NoRecovery', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (30, N'@URL', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the domain name and container for backup to Azure Blob Storage.

The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (31, N'@Credential', N'[NULL]', N'NVARCHAR(MAX)', N'Specify a CREDENTIAL for backup to Windows Azure Blob Storage.

The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (32, N'@MirrorDirectory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify one or multiple directories to perform a mirrored backup.

The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (33, N'@MirrorCleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted.

By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (34, N'@MirrorCleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (35, N'@AvailabilityGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (36, N'@Updateability', N'ALL', N'NVARCHAR(MAX)', N'Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (37, N'@LogToTable', N'Y', N'NVARCHAR(MAX)', N'Log commands to the table dbo.CommandLog.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupDiff] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (38, N'@Execute', N'Y', N'NVARCHAR(MAX)', N'Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.', CAST(N'2016-11-07' AS Date))
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupDiff] OFF
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupFull] ON 
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (1, N'@Databases', N'ALL_DATABASES', N'NVARCHAR(MAX)', N'Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (2, N'@Directory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (3, N'@BackupType', N'FULL', N'NVARCHAR(MAX)', N'Specify the type of backup: full, differential, or transaction log.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (4, N'@Verify', N'N', N'NVARCHAR(MAX)', N'Verify the backup', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (7, N'@CleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted. If no time is specified, then no backup files are deleted.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (8, N'@CleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (9, N'@Compress', N'[NULL]', N'NVARCHAR(MAX)', N'Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (10, N'@CopyOnly', N'N', N'NVARCHAR(MAX)', N'Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (11, N'@ChangeBackupType', N'Y', N'NVARCHAR(MAX)', N'Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead.

DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (12, N'@BackupSoftware', N'[NULL]', N'NVARCHAR(MAX)', N'Specify third-party backup software; otherwise, SQL Server native backup is performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (13, N'@CheckSum', N'N', N'NVARCHAR(MAX)', N'Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (14, N'@BlockSize', N'[NULL]', N'INT', N'Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (15, N'@BufferCount', N'[NULL]', N'INT', N'Specify the number of I/O buffers to be used for the backup operation.

The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (16, N'@MaxTransferSize', N'[NULL]', N'INT', N'Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media.

The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (17, N'@NumberOfFiles', N'[NULL]', N'INT', N'Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (18, N'@CompressionLevel', N'[NULL]', N'INT', N'Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level.

In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (19, N'@Description', N'[NULL]', N'NVARCHAR(MAX)', N'Enter a description for the backup.

The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (20, N'@Threads', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (21, N'@Throttle', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (22, N'@Encrypt', N'N', N'NVARCHAR(MAX)', N'Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (23, N'@EncryptionAlgorithm', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the type of encryption. The EncryptionAlgorithm option in DatabaseBackup uses the ENCRYPTION and ALGORITHM options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (24, N'@ServerCertificate', N'[NULL]', N'NVARCHAR(MAX)', N'Server certificate that is used to encrypt the backup.

The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (25, N'@ServerAsymmetricKey', N'[NULL]', N'NVARCHAR(MAX)', N'Asymmetric key that is used to encrypt the backup.

The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (26, N'@EncryptionKey', N'[NULL]', N'NVARCHAR(MAX)', N'Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. ', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (27, N'@ReadWriteFileGroups', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the primary filegroup and any read/write filegroups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (28, N'@OverrideBackupPreference', N'N', N'NVARCHAR(MAX)', N'Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (29, N'@NoRecovery', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (30, N'@URL', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the domain name and container for backup to Azure Blob Storage.

The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (31, N'@Credential', N'[NULL]', N'NVARCHAR(MAX)', N'Specify a CREDENTIAL for backup to Windows Azure Blob Storage.

The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (32, N'@MirrorDirectory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify one or multiple directories to perform a mirrored backup.

The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (33, N'@MirrorCleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted.

By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (34, N'@MirrorCleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (35, N'@AvailabilityGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (36, N'@Updateability', N'ALL', N'NVARCHAR(MAX)', N'Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (37, N'@LogToTable', N'Y', N'NVARCHAR(MAX)', N'Log commands to the table dbo.CommandLog.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupFull] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (38, N'@Execute', N'Y', N'NVARCHAR(MAX)', N'Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.', CAST(N'2016-11-07' AS Date))
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupFull] OFF
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupLog] ON 
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (1, N'@Databases', N'ALL_DATABASES', N'NVARCHAR(MAX)', N'Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (2, N'@Directory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (3, N'@BackupType', N'LOG', N'NVARCHAR(MAX)', N'Specify the type of backup: full, differential, or transaction log.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (4, N'@Verify', N'N', N'NVARCHAR(MAX)', N'Verify the backup', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (7, N'@CleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted. If no time is specified, then no backup files are deleted.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (8, N'@CleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (9, N'@Compress', N'[NULL]', N'NVARCHAR(MAX)', N'Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (10, N'@CopyOnly', N'N', N'NVARCHAR(MAX)', N'Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (11, N'@ChangeBackupType', N'Y', N'NVARCHAR(MAX)', N'Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead.

DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (12, N'@BackupSoftware', N'[NULL]', N'NVARCHAR(MAX)', N'Specify third-party backup software; otherwise, SQL Server native backup is performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (13, N'@CheckSum', N'N', N'NVARCHAR(MAX)', N'Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (14, N'@BlockSize', N'[NULL]', N'INT', N'Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (15, N'@BufferCount', N'[NULL]', N'INT', N'Specify the number of I/O buffers to be used for the backup operation.

The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (16, N'@MaxTransferSize', N'[NULL]', N'INT', N'Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media.

The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (17, N'@NumberOfFiles', N'[NULL]', N'INT', N'Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (18, N'@CompressionLevel', N'[NULL]', N'INT', N'Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level.

In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (19, N'@Description', N'[NULL]', N'NVARCHAR(MAX)', N'Enter a description for the backup.

The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (20, N'@Threads', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (21, N'@Throttle', N'[NULL]', N'INT', N'Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (22, N'@Encrypt', N'N', N'NVARCHAR(MAX)', N'Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (23, N'@EncryptionAlgorithm', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the type of encryption. The EncryptionAlgorithm option in DatabaseBackup uses the ENCRYPTION and ALGORITHM options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (24, N'@ServerCertificate', N'[NULL]', N'NVARCHAR(MAX)', N'Server certificate that is used to encrypt the backup.

The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (25, N'@ServerAsymmetricKey', N'[NULL]', N'NVARCHAR(MAX)', N'Asymmetric key that is used to encrypt the backup.

The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (26, N'@EncryptionKey', N'[NULL]', N'NVARCHAR(MAX)', N'Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. ', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (27, N'@ReadWriteFileGroups', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the primary filegroup and any read/write filegroups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (28, N'@OverrideBackupPreference', N'N', N'NVARCHAR(MAX)', N'Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (29, N'@NoRecovery', N'N', N'NVARCHAR(MAX)', N'Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (30, N'@URL', N'[NULL]', N'NVARCHAR(MAX)', N'Specify the domain name and container for backup to Azure Blob Storage.

The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (31, N'@Credential', N'[NULL]', N'NVARCHAR(MAX)', N'Specify a CREDENTIAL for backup to Windows Azure Blob Storage.

The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (32, N'@MirrorDirectory', N'[NULL]', N'NVARCHAR(MAX)', N'Specify one or multiple directories to perform a mirrored backup.

The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (33, N'@MirrorCleanupTime', N'[NULL]', N'INT', N'Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted.

By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful.

DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (34, N'@MirrorCleanupMode', N'AFTER_BACKUP', N'NVARCHAR(MAX)', N'Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (35, N'@AvailabilityGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (36, N'@Updateability', N'ALL', N'NVARCHAR(MAX)', N'Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (37, N'@LogToTable', N'Y', N'NVARCHAR(MAX)', N'Log commands to the table dbo.CommandLog.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseBackupLog] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (38, N'@Execute', N'Y', N'NVARCHAR(MAX)', N'Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.', CAST(N'2016-11-07' AS Date))
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseBackupLog] OFF
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseIntegrityCheck] ON 
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (1, N'@Databases', N'ALL_DATABASES', N'NVARCHAR(MAX)', N'Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (2, N'@CheckCommands', N'CHECKDB', N'NVARCHAR(MAX)', N'DatabaseIntegrityCheck uses these SQL Server DBCC commands: DBCC CHECKDB to check the database, DBCC CHECKFILEGROUP to check the filegroups, DBCC CHECKTABLE to check the tables and the indexed views, DBCC CHECKALLOC to check the disk space allocation structures, and DBCC CHECKCATALOG to check the catalog consistency.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (3, N'@PhysicalOnly', N'N', N'NVARCHAR(MAX)', N'The PhysicalOnly option in DatabaseIntegrityCheck uses the PHYSICAL_ONLY option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, and DBCC CHECKTABLE commands.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (4, N'@NoIndex', N'N', N'NVARCHAR(MAX)', N'The NoIndex option in DatabaseIntegrityCheck uses the NOINDEX option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, DBCC CHECKTABLE, and DBCC CHECKALLOC commands.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (5, N'@ExtendedLogicalChecks', N'N', N'NVARCHAR(MAX)', N'The ExtendedLogicalChecks option in DatabaseIntegrityCheck uses the EXTENDED_LOGICAL_CHECKS option in the SQL Server DBCC CHECKDB command.

You cannot combine the options PhysicalOnly and ExtendedLogicalChecks.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (6, N'@TabLock', N'N', N'NVARCHAR(MAX)', N'The TabLock option in DatabaseIntegrityCheck uses the TABLOCK option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, DBCC CHECKTABLE, and DBCC CHECKALLOC commands.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (7, N'@FileGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select filegroups. The ALL_FILEGROUPS keyword is supported. The hyphen character (-) is used to exclude filegroups, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (8, N'@Objects', N'[NULL]', N'NVARCHAR(MAX)', N'Select objects. The ALL_OBJECTS keyword is supported. The hyphen character (-) is used to exclude objects, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (9, N'@MaxDOP', N'[NULL]', N'INT', N'Specify the number of CPUs to use when checking the database, filegroup or table. If this number is not specified, the global maximum degree of parallelism is used.

The MaxDOP option in DatabaseIntegrityCheck uses the MAXDOP option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, and DBCC CHECKTABLE commands.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (10, N'@AvailabilityGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (11, N'@AvailabilityGroupReplicas', N'SECONDARY', N'NVARCHAR(MAX)', N'Specify which replicas in availability groups that should be checked.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (12, N'@Updateability', N'ALL', N'NVARCHAR(MAX)', N'Select READ_ONLY/READ_WRITE - databases.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (13, N'@LockTimeout', N'[NULL]', N'INT', N'Set the time, in seconds, that a command waits for a lock to be released. By default, the time is not limited.

The LockTimeout option in IndexOptimize uses the SET LOCK_TIMEOUT set statement in SQL Server.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (14, N'@LogToTable', N'Y', N'NVARCHAR(MAX)', N'Log commands to the table dbo.CommandLog.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblDatabaseIntegrityCheck] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (15, N'@Execute', N'Y', N'NVARCHAR(MAX)', N'Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.', CAST(N'2016-11-07' AS Date))
GO
SET IDENTITY_INSERT [CONFIG].[tblDatabaseIntegrityCheck] OFF
GO
SET IDENTITY_INSERT [CONFIG].[tblIndexOptimize] ON 
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (1, N'@Databases', N'ALL_DATABASES', N'NVARCHAR(MAX)', N'Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (2, N'@FragmentationLow', N'[NULL]', N'NVARCHAR(MAX)', N'An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained.

IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (3, N'@FragmentationMedium', N'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE', N'NVARCHAR(MAX)', N'An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained.

IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (4, N'@FragmentationHigh', N'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE', N'NVARCHAR(MAX)', N'An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained.

IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (5, N'@FragmentationLevel1', N'5', N'INT', N'Set the lower limit, as a percentage, for medium fragmentation. The default is 5 percent. This is based on Microsoft’s recommendation in Books Online.

IndexOptimize checks avg_fragmentation_in_percent in sys.dm_db_index_physical_stats to determine the fragmentation.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (6, N'@FragmentationLevel2', N'30', N'INT', N'Set the lower limit, as a percentage, for high fragmentation. The default is 30 percent. This is based on Microsoft’s recommendation in Books Online.

IndexOptimize checks avg_fragmentation_in_percent in sys.dm_db_index_physical_stats to determine the fragmentation.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (7, N'@PageCountLevel', N'100', N'INT', N'Set a size, in pages; indexes with fewer pages are skipped for index maintenance. The default is 1000 pages. This is based on Microsoft’s recommendation.

IndexOptimize checks page_count in sys.dm_db_index_physical_stats to determine the size of the index.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (8, N'@SortInTempdb', N'Y', N'NVARCHAR(MAX)', N'The SortInTempdb option in IndexOptimize uses the SORT_IN_TEMPDB option in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (9, N'@MaxDOP', N'[NULL]', N'INT', N'Specify the number of CPUs to use when rebuilding indexes. If this number is not specified, the global maximum degree of parallelism is used.

The MaxDOP option in IndexOptimize uses the MAXDOP option in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (10, N'@FillFactor', N'90', N'INT', N'Indicate, as a percentage, how full the pages should be made when rebuilding indexes. If a percentage is not specified, the fill factor in sys.indexes is used.

The FillFactor option in IndexOptimize uses the FILLFACTOR option in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (11, N'@PadIndex', N'N', N'NVARCHAR(MAX)', N'Apply the percentage of free space that the fill factor specifies to the intermediate-level pages of the index.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (12, N'@LOBCompaction', N'Y', N'NVARCHAR(MAX)', N'The LOBCompaction option in IndexOptimize uses the LOB_COMPACTION option in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (13, N'@UpdateStatistics', N'ALL', N'NVARCHAR(MAX)', N'IndexOptimize uses the SQL Server UPDATE STATISTICS command to update statistics.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (14, N'@OnlyModifiedStatistics', N'Y', N'NVARCHAR(MAX)', N'Update statistics only if any rows have been modified since the most recent statistics update.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (15, N'@StatisticsSample', N'[NULL]', N'INT', N'Indicate, as a percentage, how much of a table is gathered when updating statistics. A value of 100 is equivalent to a full scan. If no value is specified, then SQL Server automatically computes the required sample.

The StatisticsSample option in IndexOptimize uses the SAMPLE and FULLSCAN options in the SQL Server UPDATE STATISTICS command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (16, N'@StatisticsResample', N'N', N'NVARCHAR(MAX)', N'The StatisticsResample option in IndexOptimize uses the RESAMPLE option in the SQL Server UPDATE STATISTICS command.

You cannot combine the options StatisticsSample and StatisticsResample.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (17, N'@PartitionLevel', N'N', N'NVARCHAR(MAX)', N'Maintain partitioned indexes on the partition level. If this parameter is set to Y, the fragmentation level and page count is checked for each partition. The appropriate index maintenance (reorganize or rebuild) is then performed for each partition.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (18, N'@MSShippedObjects', N'N', N'NVARCHAR(MAX)', N'Maintain indexes and statistics on objects that are created by internal SQL Server components.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (19, N'@Indexes', N'[NULL]', N'NVARCHAR(MAX)', N'Select indexes. If this parameter is not specified, all indexes are selected. The ALL_INDEXES keyword is supported. The hyphen character (-) is used to exclude indexes, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (20, N'@TimeLimit', N'[NULL]', N'INT', N'Set the time, in seconds, after which no commands are executed. By default, the time is not limited.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (21, N'@Delay', N'[NULL]', N'INT', N'Set the delay, in seconds, between index commands. By default, there is no delay.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (22, N'@WaitAtLowPriorityMaxDuration', N'[NULL]', N'INT', N'The time, in minutes that an online index rebuild operation will wait for low priority locks.

The WaitAtLowPriorityMaxDuration option in IndexOptimize uses the WAIT_AT_LOW_PRIORITY and MAX_DURATION options in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (23, N'@WaitAtLowPriorityAbortAfterWait', N'[NULL]', N'NVARCHAR(MAX)', N'The WaitAtLowPriorityAbortAfterWait option in IndexOptimize uses the WAIT_AT_LOW_PRIORITY and ABORT_AFTER_WAIT options in the SQL Server ALTER INDEX command.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (24, N'@AvailabilityGroups', N'[NULL]', N'NVARCHAR(MAX)', N'Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (25, N'@LockTimeout', N'[NULL]', N'INT', N'Set the time, in seconds, that a command waits for a lock to be released. By default, the time is not limited.

The LockTimeout option in IndexOptimize uses the SET LOCK_TIMEOUT set statement in SQL Server.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (26, N'@LogToTable', N'Y', N'NVARCHAR(MAX)', N'Log commands to the table dbo.CommandLog.', CAST(N'2016-11-07' AS Date))
GO
INSERT [CONFIG].[tblIndexOptimize] ([id], [Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (27, N'@Execute', N'Y', N'NVARCHAR(MAX)', N'Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.', CAST(N'2016-11-07' AS Date))
GO
SET IDENTITY_INSERT [CONFIG].[tblIndexOptimize] OFF
GO
/****** Object:  StoredProcedure [dbo].[CommandExecute]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CommandExecute]

@Command nvarchar(max),
@CommandType nvarchar(max),
@Mode int,
@Comment nvarchar(max) = NULL,
@DatabaseName nvarchar(max) = NULL,
@SchemaName nvarchar(max) = NULL,
@ObjectName nvarchar(max) = NULL,
@ObjectType nvarchar(max) = NULL,
@IndexName nvarchar(max) = NULL,
@IndexType int = NULL,
@StatisticsName nvarchar(max) = NULL,
@PartitionNumber int = NULL,
@ExtendedInfo xml = NULL,
@LogToTable nvarchar(max),
@Execute nvarchar(max)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: https://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorMessageOriginal nvarchar(max)

  DECLARE @StartTime datetime
  DECLARE @EndTime datetime

  DECLARE @StartTimeSec datetime
  DECLARE @EndTimeSec datetime

  DECLARE @ID int

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @Command IS NULL OR @Command = ''
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Command is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CommandType IS NULL OR @CommandType = '' OR LEN(@CommandType) > 60
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CommandType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Mode NOT IN(1,2) OR @Mode IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Mode is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = GETDATE()
  SET @StartTimeSec = CONVERT(datetime,CONVERT(nvarchar,@StartTime,120),120)

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTimeSec,120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Command: ' + @Command
  IF @Comment IS NOT NULL SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10) + 'Comment: ' + @Comment
  SET @StartMessage = REPLACE(@StartMessage,'%','%%')
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    INSERT INTO dbo.CommandLog (DatabaseName, SchemaName, ObjectName, ObjectType, IndexName, IndexType, StatisticsName, PartitionNumber, ExtendedInfo, CommandType, Command, StartTime)
    VALUES (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber, @ExtendedInfo, @CommandType, @Command, @StartTime)
  END

  SET @ID = SCOPE_IDENTITY()

  ----------------------------------------------------------------------------------------------------
  --// Execute command                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @Mode = 1 AND @Execute = 'Y'
  BEGIN
    EXECUTE(@Command)
    SET @Error = @@ERROR
    SET @ReturnCode = @Error
  END

  IF @Mode = 2 AND @Execute = 'Y'
  BEGIN
    BEGIN TRY
      EXECUTE(@Command)
    END TRY
    BEGIN CATCH
      SET @Error = ERROR_NUMBER()
      SET @ReturnCode = @Error
      SET @ErrorMessageOriginal = ERROR_MESSAGE()
      SET @ErrorMessage = 'Msg ' + CAST(@Error AS nvarchar) + ', ' + ISNULL(@ErrorMessageOriginal,'')
      RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    END CATCH
  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  SET @EndTime = GETDATE()
  SET @EndTimeSec = CONVERT(datetime,CONVERT(varchar,@EndTime,120),120)

  SET @EndMessage = 'Outcome: ' + CASE WHEN @Execute = 'N' THEN 'Not Executed' WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END + CHAR(13) + CHAR(10)
  SET @EndMessage = @EndMessage + 'Duration: ' + CASE WHEN DATEDIFF(ss,@StartTimeSec, @EndTimeSec)/(24*3600) > 0 THEN CAST(DATEDIFF(ss,@StartTimeSec, @EndTimeSec)/(24*3600) AS nvarchar) + '.' ELSE '' END + CONVERT(nvarchar,@EndTimeSec - @StartTimeSec,108) + CHAR(13) + CHAR(10)
  SET @EndMessage = @EndMessage + 'Date and time: ' + CONVERT(nvarchar,@EndTimeSec,120) + CHAR(13) + CHAR(10) + ' '
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    UPDATE dbo.CommandLog
    SET EndTime = @EndTime,
        ErrorNumber = CASE WHEN @Execute = 'N' THEN NULL ELSE @Error END,
        ErrorMessage = @ErrorMessageOriginal
    WHERE ID = @ID
  END

  ReturnCode:
  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO
/****** Object:  StoredProcedure [dbo].[DatabaseBackup]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseBackup]

@Databases nvarchar(max) = NULL,
@Directory nvarchar(max) = NULL,
@BackupType nvarchar(max),
@Verify nvarchar(max) = 'N',
@CleanupTime int = NULL,
@CleanupMode nvarchar(max) = 'AFTER_BACKUP',
@Compress nvarchar(max) = NULL,
@CopyOnly nvarchar(max) = 'N',
@ChangeBackupType nvarchar(max) = 'N',
@BackupSoftware nvarchar(max) = NULL,
@CheckSum nvarchar(max) = 'N',
@BlockSize int = NULL,
@BufferCount int = NULL,
@MaxTransferSize int = NULL,
@NumberOfFiles int = NULL,
@CompressionLevel int = NULL,
@Description nvarchar(max) = NULL,
@Threads int = NULL,
@Throttle int = NULL,
@Encrypt nvarchar(max) = 'N',
@EncryptionAlgorithm nvarchar(max) = NULL,
@ServerCertificate nvarchar(max) = NULL,
@ServerAsymmetricKey nvarchar(max) = NULL,
@EncryptionKey nvarchar(max) = NULL,
@ReadWriteFileGroups nvarchar(max) = 'N',
@OverrideBackupPreference nvarchar(max) = 'N',
@NoRecovery nvarchar(max) = 'N',
@URL nvarchar(max) = NULL,
@Credential nvarchar(max) = NULL,
@MirrorDirectory nvarchar(max) = NULL,
@MirrorCleanupTime int = NULL,
@MirrorCleanupMode nvarchar(max) = 'AFTER_BACKUP',
@AvailabilityGroups nvarchar(max) = NULL,
@Updateability nvarchar(max) = 'ALL',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: https://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)
  DECLARE @AmazonRDS bit

  DECLARE @Cluster nvarchar(max)

  DECLARE @DefaultDirectory nvarchar(4000)

  DECLARE @CurrentRootDirectoryID int
  DECLARE @CurrentRootDirectoryPath nvarchar(4000)

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentBackupType nvarchar(max)
  DECLARE @CurrentFileExtension nvarchar(max)
  DECLARE @CurrentFileNumber int
  DECLARE @CurrentDifferentialBaseLSN numeric(25,0)
  DECLARE @CurrentDifferentialBaseIsSnapshot bit
  DECLARE @CurrentLogLSN numeric(25,0)
  DECLARE @CurrentLatestBackup datetime
  DECLARE @CurrentDatabaseNameFS nvarchar(max)
  DECLARE @CurrentDirectoryID int
  DECLARE @CurrentDirectoryPath nvarchar(max)
  DECLARE @CurrentFilePath nvarchar(max)
  DECLARE @CurrentDate datetime
  DECLARE @CurrentCleanupDate datetime
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentAvailabilityGroupBackupPreference nvarchar(max)
  DECLARE @CurrentIsPreferredBackupReplica bit
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)
  DECLARE @CurrentLogShippingRole nvarchar(max)
  DECLARE @CurrentIsEncrypted bit
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentBackupSetID int
  DECLARE @CurrentIsMirror bit

  DECLARE @CurrentCommand01 nvarchar(max)
  DECLARE @CurrentCommand02 nvarchar(max)
  DECLARE @CurrentCommand03 nvarchar(max)
  DECLARE @CurrentCommand04 nvarchar(max)
  DECLARE @CurrentCommand05 nvarchar(max)
  DECLARE @CurrentCommand06 nvarchar(max)

  DECLARE @CurrentCommandOutput01 int
  DECLARE @CurrentCommandOutput02 int
  DECLARE @CurrentCommandOutput03 int
  DECLARE @CurrentCommandOutput04 int
  DECLARE @CurrentCommandOutput05 int

  DECLARE @CurrentCommandType01 nvarchar(max)
  DECLARE @CurrentCommandType02 nvarchar(max)
  DECLARE @CurrentCommandType03 nvarchar(max)
  DECLARE @CurrentCommandType04 nvarchar(max)
  DECLARE @CurrentCommandType05 nvarchar(max)

  DECLARE @Directories TABLE (ID int PRIMARY KEY,
                              DirectoryPath nvarchar(max),
                              Mirror bit,
                              Completed bit)

  DECLARE @DirectoryInfo TABLE (FileExists bit,
                                FileIsADirectory bit,
                                ParentDirectoryExists bit)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseNameFS nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max), AvailabilityGroupName nvarchar(max))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             Selected bit)

  DECLARE @CurrentBackupSet TABLE (ID int IDENTITY PRIMARY KEY,
                                   Mirror bit,
                                   VerifyCompleted bit,
                                   VerifyOutput int)

  DECLARE @CurrentDirectories TABLE (ID int PRIMARY KEY,
                                     DirectoryPath nvarchar(max),
                                     Mirror bit,
                                     DirectoryNumber int,
                                     CleanupDate datetime,
                                     CleanupMode nvarchar(max),
                                     CreateCompleted bit,
                                     CleanupCompleted bit,
                                     CreateOutput int,
                                     CleanupOutput int)

  DECLARE @CurrentFiles TABLE ([Type] nvarchar(max),
                               FilePath nvarchar(max),
                               Mirror bit)

  DECLARE @CurrentCleanupDates TABLE (CleanupDate datetime, Mirror bit)

  DECLARE @DirectoryCheck bit

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  SET @AmazonRDS = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Directory = ' + ISNULL('''' + REPLACE(@Directory,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BackupType = ' + ISNULL('''' + REPLACE(@BackupType,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Verify = ' + ISNULL('''' + REPLACE(@Verify,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @CleanupMode = ' + ISNULL('''' + REPLACE(@CleanupMode,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Compress = ' + ISNULL('''' + REPLACE(@Compress,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CopyOnly = ' + ISNULL('''' + REPLACE(@CopyOnly,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ChangeBackupType = ' + ISNULL('''' + REPLACE(@ChangeBackupType,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BackupSoftware = ' + ISNULL('''' + REPLACE(@BackupSoftware,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CheckSum = ' + ISNULL('''' + REPLACE(@CheckSum,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BlockSize = ' + ISNULL(CAST(@BlockSize AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @BufferCount = ' + ISNULL(CAST(@BufferCount AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @MaxTransferSize = ' + ISNULL(CAST(@MaxTransferSize AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @NumberOfFiles = ' + ISNULL(CAST(@NumberOfFiles AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @CompressionLevel = ' + ISNULL(CAST(@CompressionLevel AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Description = ' + ISNULL('''' + REPLACE(@Description,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Threads = ' + ISNULL(CAST(@Threads AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Throttle = ' + ISNULL(CAST(@Throttle AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Encrypt = ' + ISNULL('''' + REPLACE(@Encrypt,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @EncryptionAlgorithm = ' + ISNULL('''' + REPLACE(@EncryptionAlgorithm,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ServerCertificate = ' + ISNULL('''' + REPLACE(@ServerCertificate,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ServerAsymmetricKey = ' + ISNULL('''' + REPLACE(@ServerAsymmetricKey,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @EncryptionKey = ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ReadWriteFileGroups = ' + ISNULL('''' + REPLACE(@ReadWriteFileGroups,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @OverrideBackupPreference = ' + ISNULL('''' + REPLACE(@OverrideBackupPreference,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @NoRecovery = ' + ISNULL('''' + REPLACE(@NoRecovery,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @URL = ' + ISNULL('''' + REPLACE(@URL,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Credential = ' + ISNULL('''' + REPLACE(@Credential,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MirrorDirectory = ' + ISNULL('''' + REPLACE(@MirrorDirectory,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MirrorCleanupTime = ' + ISNULL(CAST(@MirrorCleanupTime AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @MirrorCleanupMode = ' + ISNULL('''' + REPLACE(@MirrorCleanupMode,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: https://ola.hallengren.com' + CHAR(13) + CHAR(10)
  SET @StartMessage = REPLACE(@StartMessage,'%','%%') + ' '
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND (OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%' OR OBJECT_DEFINITION(objects.[object_id]) LIKE '%LOCK_TIMEOUT%'))
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @AmazonRDS = 1
  BEGIN
    SET @ErrorMessage = 'The stored procedure DatabaseBackup is not supported on Amazon RDS.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(', ',@Databases) > 0 SET @Databases = REPLACE(@Databases,', ',',')
  WHILE CHARINDEX(' ,',@Databases) > 0 SET @Databases = REPLACE(@Databases,' ,',',')

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('EngineEdition') <> 5
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseNameFS, DatabaseType, AvailabilityGroup, Selected, Completed)
    SELECT [name] AS DatabaseName,
           LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([name],'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))) AS DatabaseNameFS,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           CASE WHEN name IN (SELECT availability_databases_cluster.database_name FROM sys.availability_databases_cluster availability_databases_cluster) THEN 1 ELSE 0 END AS AvailabilityGroup,
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    WHERE [name] <> 'tempdb'
    AND source_database_id IS NULL
    ORDER BY [name] ASC
  END
  ELSE
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseNameFS, DatabaseType, AvailabilityGroup, Selected, Completed)
    SELECT [name] AS DatabaseName,
           LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([name],'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))) AS DatabaseNameFS,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           NULL AS AvailabilityGroup,
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    WHERE [name] <> 'tempdb'
    AND source_database_id IS NULL
    ORDER BY [name] ASC
  END

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 0

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(', ',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,', ',',')
    WHILE CHARINDEX(' ,',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,' ,',',')

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT AvailabilityGroupName, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT availability_databases_cluster.database_name, availability_groups.name
    FROM sys.availability_databases_cluster availability_databases_cluster
    INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id

    UPDATE tmpDatabases
    SET Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @AvailabilityGroups is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    SET @ErrorMessage = 'You need to specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'You can only specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Check database names                                                                       //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @tmpDatabases
  WHERE Selected = 1
  AND DatabaseNameFS = ''
  ORDER BY DatabaseName ASC
  IF @@ROWCOUNT > 0
  BEGIN
    SET @ErrorMessage = 'The names of the following databases are not supported: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @tmpDatabases
  WHERE UPPER(DatabaseNameFS) IN(SELECT UPPER(DatabaseNameFS) FROM @tmpDatabases GROUP BY UPPER(DatabaseNameFS) HAVING COUNT(*) > 1)
  AND UPPER(DatabaseNameFS) IN(SELECT UPPER(DatabaseNameFS) FROM @tmpDatabases WHERE Selected = 1)
  AND DatabaseNameFS <> ''
  ORDER BY DatabaseName ASC
  OPTION (RECOMPILE)
  IF @@ROWCOUNT > 0
  BEGIN
    SET @ErrorMessage = 'The names of the following databases are not unique in the file system: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select directories                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @Directory IS NULL AND @URL IS NULL
  BEGIN
    EXECUTE [master].dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @DefaultDirectory OUTPUT

    INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
    SELECT 1, @DefaultDirectory, 0, 0
  END
  ELSE
  BEGIN
    SET @Directory = REPLACE(@Directory, CHAR(10), '')
    SET @Directory = REPLACE(@Directory, CHAR(13), '')

    WHILE CHARINDEX(', ',@Directory) > 0 SET @Directory = REPLACE(@Directory,', ',',')
    WHILE CHARINDEX(' ,',@Directory) > 0 SET @Directory = REPLACE(@Directory,' ,',',')

    SET @Directory = LTRIM(RTRIM(@Directory));

    WITH Directories (StartPosition, EndPosition, Directory) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @Directory, 1), 0), LEN(@Directory) + 1) AS EndPosition,
           SUBSTRING(@Directory, 1, ISNULL(NULLIF(CHARINDEX(',', @Directory, 1), 0), LEN(@Directory) + 1) - 1) AS Directory
    WHERE @Directory IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) AS EndPosition,
           SUBSTRING(@Directory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) - EndPosition - 1) AS Directory
    FROM Directories
    WHERE EndPosition < LEN(@Directory) + 1
    )
    INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
    SELECT ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
           Directory,
           0,
           0
    FROM Directories
    OPTION (MAXRECURSION 0)
  END

  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(10), '')
  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(13), '')

  WHILE CHARINDEX(', ',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,', ',',')
  WHILE CHARINDEX(' ,',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,' ,',',')

  SET @MirrorDirectory = LTRIM(RTRIM(@MirrorDirectory));

  WITH Directories (StartPosition, EndPosition, Directory) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, 1, ISNULL(NULLIF(CHARINDEX(',', @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) - 1) AS Directory
  WHERE @MirrorDirectory IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) - EndPosition - 1) AS Directory
  FROM Directories
  WHERE EndPosition < LEN(@MirrorDirectory) + 1
  )
  INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
  SELECT (SELECT COUNT(*) FROM @Directories) + ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
         Directory,
         1,
         0
  FROM Directories
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check directories                                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET @DirectoryCheck = 1

  IF EXISTS(SELECT * FROM @Directories WHERE Mirror = 0 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%') OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' ')) OR EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1) OR ((SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 0)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Directory is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
    SET @DirectoryCheck = 0
  END

  IF EXISTS(SELECT * FROM @Directories WHERE Mirror = 1 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%') OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' ')) OR EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1) OR ((SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 0) OR (@BackupSoftware IN('SQLBACKUP','SQLSAFE') AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 1) OR (@BackupSoftware IS NULL AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1) AND SERVERPROPERTY('EngineEdition') <> 3)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MirrorDirectory is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
    SET @DirectoryCheck = 0
  END

  IF @DirectoryCheck = 1
  BEGIN
    WHILE EXISTS(SELECT * FROM @Directories WHERE Completed = 0)
    BEGIN
      SELECT TOP 1 @CurrentRootDirectoryID = ID,
                   @CurrentRootDirectoryPath = DirectoryPath
      FROM @Directories
      WHERE Completed = 0
      ORDER BY ID ASC

      INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
      EXECUTE [master].dbo.xp_fileexist @CurrentRootDirectoryPath

      IF NOT EXISTS (SELECT * FROM @DirectoryInfo WHERE FileExists = 0 AND FileIsADirectory = 1 AND ParentDirectoryExists = 1)
      BEGIN
        SET @ErrorMessage = 'The directory ' + @CurrentRootDirectoryPath + ' does not exist.' + CHAR(13) + CHAR(10) + ' '
        RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
        SET @Error = @@ERROR
      END

      UPDATE @Directories
      SET Completed = 1
      WHERE ID = @CurrentRootDirectoryID

      SET @CurrentRootDirectoryID = NULL
      SET @CurrentRootDirectoryPath = NULL

      DELETE FROM @DirectoryInfo
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Get default compression                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF @Compress IS NULL
  BEGIN
    SELECT @Compress = CASE
    WHEN @BackupSoftware IS NULL AND EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'Y'
    WHEN @BackupSoftware IS NULL AND NOT EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'N'
    WHEN @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel > 0)  THEN 'Y'
    WHEN @BackupSoftware IS NOT NULL AND @CompressionLevel = 0  THEN 'N'
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Get number of files                                                                        //--
  ----------------------------------------------------------------------------------------------------

  IF @NumberOfFiles IS NULL
  BEGIN
    SELECT @NumberOfFiles = CASE WHEN @URL IS NOT NULL THEN 1 ELSE (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) END
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @BackupType NOT IN ('FULL','DIFF','LOG') OR @BackupType IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @BackupType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Verify NOT IN ('Y','N') OR @Verify IS NULL OR (@BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND @Verify = 'Y')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Verify is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CleanupTime < 0 OR (@CleanupTime IS NOT NULL AND @URL IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CleanupTime is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @CleanupMode IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CleanupMode is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Compress NOT IN ('Y','N') OR @Compress IS NULL OR (@Compress = 'Y' AND @BackupSoftware IS NULL AND NOT ((@Version >= 10 AND @Version < 10.5 AND SERVERPROPERTY('EngineEdition') = 3) OR (@Version >= 10.5 AND (SERVERPROPERTY('EngineEdition') = 3 OR SERVERPROPERTY('EditionID') IN (-1534726760, 284895786))))) OR (@Compress = 'N' AND @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel >= 1)) OR (@Compress = 'Y' AND @BackupSoftware IS NOT NULL AND @CompressionLevel = 0)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Compress is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CopyOnly NOT IN ('Y','N') OR @CopyOnly IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CopyOnly is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @ChangeBackupType NOT IN ('Y','N') OR @ChangeBackupType IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @ChangeBackupType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware NOT IN ('LITESPEED','SQLBACKUP','SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @BackupSoftware is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'LITESPEED' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_backup_database')
  BEGIN
    SET @ErrorMessage = 'LiteSpeed for SQL Server is not installed. Download http://software.dell.com/products/litespeed-for-sql-server/.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'SQLBACKUP' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'sqlbackup')
  BEGIN
    SET @ErrorMessage = 'Red Gate SQL Backup Pro is not installed. Download http://www.red-gate.com/products/dba/sql-backup/.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'SQLSAFE' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_ss_backup')
  BEGIN
    SET @ErrorMessage = 'Idera SQL Safe Backup is not installed. Download https://www.idera.com/productssolutions/sqlserver/sqlsafebackup.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CheckSum NOT IN ('Y','N') OR @CheckSum IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CheckSum is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BlockSize NOT IN (512,1024,2048,4096,8192,16384,32768,65536) OR (@BlockSize IS NOT NULL AND @BackupSoftware = 'SQLBACKUP') OR (@BlockSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE') OR (@BlockSize IS NOT NULL AND @URL IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @BlockSize is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BufferCount <= 0 OR @BufferCount > 2147483647 OR (@BufferCount IS NOT NULL AND @BackupSoftware = 'SQLBACKUP') OR (@BufferCount IS NOT NULL AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @BufferCount is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxTransferSize < 65536 OR @MaxTransferSize > 4194304 OR @MaxTransferSize % 65536 > 0 OR (@MaxTransferSize > 1048576 AND @BackupSoftware = 'SQLBACKUP') OR (@MaxTransferSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE') OR (@MaxTransferSize IS NOT NULL AND @URL IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MaxTransferSize is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @NumberOfFiles < 1 OR @NumberOfFiles > 64 OR (@NumberOfFiles > 32 AND @BackupSoftware = 'SQLBACKUP') OR @NumberOfFiles IS NULL OR @NumberOfFiles < (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) OR @NumberOfFiles % (SELECT NULLIF(COUNT(*),0) FROM @Directories WHERE Mirror = 0) > 0 OR (@URL IS NOT NULL AND @NumberOfFiles <> 1) OR (@NumberOfFiles > 1 AND @BackupSoftware IN('SQLBACKUP','SQLSAFE') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @NumberOfFiles is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@BackupSoftware IS NULL AND @CompressionLevel IS NOT NULL) OR (@BackupSoftware = 'LITESPEED' AND (@CompressionLevel < 0 OR @CompressionLevel > 8)) OR (@BackupSoftware = 'SQLBACKUP' AND (@CompressionLevel < 0 OR @CompressionLevel > 4)) OR (@BackupSoftware = 'SQLSAFE' AND (@CompressionLevel < 1 OR @CompressionLevel > 4))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CompressionLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF LEN(@Description) > 255 OR (@BackupSoftware = 'LITESPEED' AND LEN(@Description) > 128)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Description is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Threads IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED','SQLBACKUP','SQLSAFE') OR @BackupSoftware IS NULL) OR (@BackupSoftware = 'LITESPEED' AND (@Threads < 1 OR @Threads > 32)) OR (@BackupSoftware = 'SQLBACKUP' AND (@Threads < 2 OR @Threads > 32)) OR (@BackupSoftware = 'SQLSAFE' AND (@Threads < 1 OR @Threads > 64))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Threads is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Throttle IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL) OR @Throttle < 1 OR @Throttle > 100
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Throttle is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Encrypt NOT IN('Y','N') OR @Encrypt IS NULL OR (@Encrypt = 'Y' AND @BackupSoftware IS NULL AND NOT (@Version >= 12 AND (SERVERPROPERTY('EngineEdition') = 3) OR SERVERPROPERTY('EditionID') IN(-1534726760, 284895786)))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Encrypt is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@BackupSoftware IS NULL AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_192','AES_256','TRIPLE_DES_3KEY') OR @EncryptionAlgorithm IS NULL)) OR (@BackupSoftware = 'LITESPEED' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('RC2_40','RC2_56','RC2_112','RC2_128','TRIPLE_DES_3KEY','RC4_128','AES_128','AES_192','AES_256') OR @EncryptionAlgorithm IS NULL)) OR (@BackupSoftware = 'SQLBACKUP' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL)) OR (@BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @EncryptionAlgorithm is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerCertificate IS NOT NULL) OR (@BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NULL AND @ServerAsymmetricKey IS NULL) OR (@BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL AND @ServerAsymmetricKey IS NOT NULL) OR (@ServerCertificate IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.certificates WHERE name = @ServerCertificate))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @ServerCertificate is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerAsymmetricKey IS NOT NULL) OR (@BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NULL AND @ServerCertificate IS NULL) OR (@BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL AND @ServerCertificate IS NOT NULL) OR (@ServerAsymmetricKey IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.asymmetric_keys WHERE name = @ServerAsymmetricKey))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @ServerAsymmetricKey is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@EncryptionKey IS NOT NULL AND @BackupSoftware IS NULL) OR (@EncryptionKey IS NOT NULL AND @Encrypt = 'N') OR (@EncryptionKey IS NULL AND @Encrypt = 'Y' AND @BackupSoftware IN('LITESPEED','SQLBACKUP','SQLSAFE'))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @EncryptionKey is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @ReadWriteFileGroups NOT IN('Y','N') OR @ReadWriteFileGroups IS NULL OR (@ReadWriteFileGroups = 'Y' AND @BackupType = 'LOG')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @ReadWriteFileGroups is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @OverrideBackupPreference NOT IN('Y','N') OR @OverrideBackupPreference IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @OverrideBackupPreference is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @NoRecovery NOT IN('Y','N') OR @NoRecovery IS NULL OR (@NoRecovery = 'Y' AND @BackupType <> 'LOG') OR (@NoRecovery = 'Y' AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @NoRecovery is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@URL IS NOT NULL AND @Directory IS NOT NULL) OR (@URL IS NOT NULL AND @MirrorDirectory IS NOT NULL) OR (@URL IS NOT NULL AND @Version < 11.03339) OR (@URL IS NOT NULL AND @BackupSoftware IS NOT NULL) OR (@URL NOT LIKE 'https://%/%')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @URL is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Credential IS NULL AND @URL IS NOT NULL AND @Version < 13) OR (@Credential IS NOT NULL AND @URL IS NULL) OR (@URL IS NOT NULL AND @Credential IS NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE credential_identity = 'SHARED ACCESS SIGNATURE')) OR (@Credential IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE name = @Credential))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Credential is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MirrorCleanupTime < 0 OR (@MirrorCleanupTime IS NOT NULL AND @MirrorDirectory IS NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MirrorCleanupTime is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MirrorCleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @MirrorCleanupMode IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MirrorCleanupMode is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Updateability is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available at https://ola.hallengren.com/sql-server-backup.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Check Availability Group cluster name                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Version >= 11
  BEGIN
    SELECT @Cluster = cluster_name
    FROM sys.dm_hadr_cluster
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute backup commands                                                                    //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Selected = 1 AND Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentDBID = ID,
                 @CurrentDatabaseName = DatabaseName,
                 @CurrentDatabaseNameFS = DatabaseNameFS
    FROM @tmpDatabases
    WHERE Selected = 1
    AND Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    SELECT @CurrentDifferentialBaseLSN = differential_base_lsn
    FROM sys.master_files
    WHERE database_id = @CurrentDatabaseID
    AND [type] = 0
    AND [file_id] = 1

    -- Workaround for a bug in SQL Server 2005
    IF @Version >= 9 AND @Version < 10
    AND EXISTS(SELECT * FROM sys.master_files WHERE database_id = @CurrentDatabaseID AND [type] = 0 AND [file_id] = 1 AND differential_base_lsn IS NOT NULL AND differential_base_guid IS NOT NULL AND differential_base_time IS NULL)
    BEGIN
      SET @CurrentDifferentialBaseLSN = NULL
    END

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    BEGIN
      SELECT @CurrentLogLSN = last_log_backup_lsn
      FROM sys.database_recovery_status
      WHERE database_id = @CurrentDatabaseID
    END

    SET @CurrentBackupType = @BackupType

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'LOG' AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') <> 'SIMPLE' AND @CurrentLogLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'DIFF'
      END
      IF @CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END

    IF @CurrentBackupType = 'LOG' AND (@CleanupTime IS NOT NULL OR @MirrorCleanupTime IS NOT NULL)
    BEGIN
      SELECT @CurrentLatestBackup = MAX(backup_finish_date)
      FROM msdb.dbo.backupset
      WHERE ([type] IN('D','I')
      OR database_backup_lsn < @CurrentDifferentialBaseLSN)
      AND is_damaged = 0
      AND database_name = @CurrentDatabaseName
    END

    IF @CurrentBackupType = 'DIFF'
    BEGIN
      SELECT @CurrentDifferentialBaseIsSnapshot = is_snapshot
      FROM msdb.dbo.backupset
      WHERE database_name = @CurrentDatabaseName
      AND [type] = 'D'
      AND checkpoint_lsn = @CurrentDifferentialBaseLSN
    END

    IF @Version >= 11 AND @Cluster IS NOT NULL
    BEGIN
      SELECT @CurrentAvailabilityGroup = availability_groups.name,
             @CurrentAvailabilityGroupRole = dm_hadr_availability_replica_states.role_desc,
             @CurrentAvailabilityGroupBackupPreference = UPPER(availability_groups.automated_backup_preference_desc)
      FROM sys.databases databases
      INNER JOIN sys.availability_databases_cluster availability_databases_cluster ON databases.group_database_id = availability_databases_cluster.group_database_id
      INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id
      INNER JOIN sys.dm_hadr_availability_replica_states dm_hadr_availability_replica_states ON availability_groups.group_id = dm_hadr_availability_replica_states.group_id AND databases.replica_id = dm_hadr_availability_replica_states.replica_id
      WHERE databases.name = @CurrentDatabaseName
    END

    IF @Version >= 11 AND @Cluster IS NOT NULL AND @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SELECT @CurrentIsPreferredBackupReplica = sys.fn_hadr_backup_is_preferred_replica(@CurrentDatabaseName)
    END

    SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
    FROM sys.database_mirroring
    WHERE database_id = @CurrentDatabaseID

    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_primary_databases WHERE primary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'PRIMARY'
    END
    ELSE
    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_secondary_databases WHERE secondary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'SECONDARY'
    END

    SELECT @CurrentIsReadOnly = is_read_only
    FROM sys.databases
    WHERE name = @CurrentDatabaseName

    IF @Version >= 10
    BEGIN
      SET @CurrentCommand06 = 'SELECT @ParamIsEncrypted = is_encrypted FROM sys.databases WHERE name = @ParamDatabaseName'

      EXECUTE sp_executesql @statement = @CurrentCommand06, @params = N'@ParamDatabaseName nvarchar(max), @ParamIsEncrypted bit OUTPUT', @ParamDatabaseName = @CurrentDatabaseName, @ParamIsEncrypted = @CurrentIsEncrypted OUTPUT
    END

    -- Set database message
    SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    IF @CurrentIsDatabaseAccessible IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Encrypted: ' + CASE WHEN @CurrentIsEncrypted = 1 THEN 'Yes' WHEN @CurrentIsEncrypted = 0 THEN 'No' ELSE 'N/A' END + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group: ' + @CurrentAvailabilityGroup + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group role: ' + @CurrentAvailabilityGroupRole + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group backup preference: ' + @CurrentAvailabilityGroupBackupPreference + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Is preferred backup replica: ' + CASE WHEN @CurrentIsPreferredBackupReplica = 1 THEN 'Yes' WHEN @CurrentIsPreferredBackupReplica = 0 THEN 'No' ELSE 'N/A' END + CHAR(13) + CHAR(10)
    IF @CurrentDatabaseMirroringRole IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Database mirroring role: ' + @CurrentDatabaseMirroringRole + CHAR(13) + CHAR(10)
    IF @CurrentLogShippingRole IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Log shipping role: ' + @CurrentLogShippingRole + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Differential base LSN: ' + ISNULL(CAST(@CurrentDifferentialBaseLSN AS nvarchar),'N/A') + CHAR(13) + CHAR(10)
    IF @CurrentBackupType = 'DIFF' SET @DatabaseMessage = @DatabaseMessage + 'Differential base is snapshot: ' + CASE WHEN @CurrentDifferentialBaseIsSnapshot = 1 THEN 'Yes' WHEN @CurrentDifferentialBaseIsSnapshot = 0 THEN 'No' ELSE 'N/A' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Last log backup LSN: ' + ISNULL(CAST(@CurrentLogLSN AS nvarchar),'N/A') + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%') + ' '
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND (@CurrentIsDatabaseAccessible = 1 OR @CurrentIsDatabaseAccessible IS NULL)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 0
    AND NOT (@CurrentBackupType = 'LOG' AND (DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') = 'SIMPLE' OR @CurrentLogLSN IS NULL))
    AND NOT (@CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseLSN IS NULL)
    AND NOT (@CurrentBackupType IN('DIFF','LOG') AND @CurrentDatabaseName = 'master')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'N' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'Y' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'DIFF' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'N' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'Y' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT ((@CurrentLogShippingRole = 'PRIMARY' AND @CurrentLogShippingRole IS NOT NULL) AND @CurrentBackupType = 'LOG')
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    BEGIN

      -- Set variables
      SET @CurrentDate = GETDATE()

      INSERT INTO @CurrentCleanupDates (CleanupDate)
      SELECT @CurrentDate

      IF @CurrentBackupType = 'LOG'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate)
        SELECT @CurrentLatestBackup
      END

      SELECT @CurrentFileExtension = CASE
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'FULL' THEN 'bak'
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'DIFF' THEN 'bak'
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'LOG' THEN 'trn'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'FULL' THEN 'bak'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'DIFF' THEN 'bak'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'LOG' THEN 'trn'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'FULL' THEN 'sqb'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'DIFF' THEN 'sqb'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'LOG' THEN 'sqb'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'FULL' THEN 'safe'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'DIFF' THEN 'safe'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'LOG' THEN 'safe'
      END

      INSERT INTO @CurrentDirectories (ID, DirectoryPath, Mirror, DirectoryNumber, CreateCompleted, CleanupCompleted)
      SELECT ROW_NUMBER() OVER (ORDER BY ID), DirectoryPath + CASE WHEN RIGHT(DirectoryPath,1) = '\' THEN '' ELSE '\' END + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster + '$' + @CurrentAvailabilityGroup ELSE REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar(max)),'\','$') END + '\' + @CurrentDatabaseNameFS + '\' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END, Mirror, ROW_NUMBER() OVER (PARTITION BY Mirror ORDER BY ID ASC), 0, 0
      FROM @Directories
      ORDER BY ID ASC

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 0)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @NumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @NumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @NumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0)
          AND Mirror = 0

          SET @CurrentFilePath = @CurrentDirectoryPath + '\' + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster + '$' + @CurrentAvailabilityGroup ELSE REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar(max)),'\','$') END + '_' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension

          IF LEN(@CurrentFilePath) > 259
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + '\' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension
          END

          IF LEN(@CurrentFilePath) > 259
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + '\' + LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) END) + '...' + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension
          END

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 0

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END
      ELSE
      IF @URL IS NOT NULL
      BEGIN
        SET @CurrentFilePath = @URL + CASE WHEN RIGHT(@URL,1) = '/' THEN '' ELSE '/' END + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster + '$' + @CurrentAvailabilityGroup ELSE REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar(max)),'\','$') END + '_' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + '.' + @CurrentFileExtension

        IF LEN(@CurrentFilePath) > 259
        BEGIN
          SET @CurrentFilePath = @URL + CASE WHEN RIGHT(@URL,1) = '/' THEN '' ELSE '/' END + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + '.' + @CurrentFileExtension
        END

        IF LEN(@CurrentFilePath) > 259
        BEGIN
          SET @CurrentFilePath = @URL + CASE WHEN RIGHT(@URL,1) = '/' THEN '' ELSE '/' END + LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) END) + '...' + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + '.' + @CurrentFileExtension
        END

        INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
        SELECT 'URL', @CurrentFilePath, 0

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 1)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @NumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @NumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @NumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1)
          AND Mirror = 1

          SET @CurrentFilePath = @CurrentDirectoryPath + '\' + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster + '$' + @CurrentAvailabilityGroup ELSE REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar(max)),'\','$') END + '_' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension

          IF LEN(@CurrentFilePath) > 259
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + '\' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension
          END

          IF LEN(@CurrentFilePath) > 259
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + '\' + LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) END) + '...' + '_' + UPPER(@CurrentBackupType) + CASE WHEN @ReadWriteFileGroups = 'Y' THEN '_PARTIAL' ELSE '' END + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension
          END

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 1

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 1, 0
      END

      -- Create directory
      WHILE EXISTS (SELECT * FROM @CurrentDirectories WHERE CreateCompleted = 0)
      BEGIN
        SELECT TOP 1 @CurrentDirectoryID = ID,
                     @CurrentDirectoryPath = DirectoryPath
        FROM @CurrentDirectories
        WHERE CreateCompleted = 0
        ORDER BY ID ASC

        SET @CurrentCommandType01 = 'xp_create_subdir'
        SET @CurrentCommand01 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_create_subdir N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'
        EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @Command = @CurrentCommand01, @CommandType = @CurrentCommandType01, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
        IF @CurrentCommandOutput01 <> 0 SET @ReturnCode = @CurrentCommandOutput01

        UPDATE @CurrentDirectories
        SET CreateCompleted = 1,
            CreateOutput = @CurrentCommandOutput01
        WHERE ID = @CurrentDirectoryID

        SET @CurrentDirectoryID = NULL
        SET @CurrentDirectoryPath = NULL

        SET @CurrentCommand01 = NULL

        SET @CurrentCommandOutput01 = NULL

        SET @CurrentCommandType01 = NULL
      END

      IF @CleanupMode = 'BEFORE_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),GETDATE()), 0

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 0 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 0 OR Mirror IS NULL)),
              CleanupMode = 'BEFORE_BACKUP'
          WHERE Mirror = 0
        END
      END

      IF @MirrorCleanupMode = 'BEFORE_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@MirrorCleanupTime),GETDATE()), 1

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 1 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 1 OR Mirror IS NULL)),
              CleanupMode = 'BEFORE_BACKUP'
          WHERE Mirror = 1
        END
      END

      -- Delete old backup files, before backup
      IF NOT EXISTS (SELECT * FROM @CurrentDirectories WHERE CreateOutput <> 0 OR CreateOutput IS NULL)
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE EXISTS (SELECT * FROM @CurrentDirectories WHERE CleanupDate IS NOT NULL AND CleanupMode = 'BEFORE_BACKUP' AND CleanupCompleted = 0)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentCommandType02 = 'xp_delete_file'

            SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentCommandType02 = 'xp_slssqlmaint'

            SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentCommandType02 = 'sqbutility'

            SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentCommandType02 = 'xp_ss_delete'

            SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput02 = [dbo].[CommandExecute] @Command = @CurrentCommand02, @CommandType = @CurrentCommandType02, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput02 = @Error
          IF @CurrentCommandOutput02 <> 0 SET @ReturnCode = @CurrentCommandOutput02

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput02
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentCommand02 = NULL

          SET @CurrentCommandOutput02 = NULL

          SET @CurrentCommandType02 = NULL
        END
      END

      -- Perform a backup
      IF NOT EXISTS (SELECT * FROM @CurrentDirectories WHERE CreateOutput <> 0 OR CreateOutput IS NULL)
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SELECT @CurrentCommandType03 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP_DATABASE'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP_LOG'
          END

          SELECT @CurrentCommand03 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand03 = @CurrentCommand03 + ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand03 = @CurrentCommand03 + ' TO'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand03 = @CurrentCommand03 + ' MIRROR TO'

            SELECT @CurrentCommand03 = @CurrentCommand03 + ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand03 = @CurrentCommand03 + ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand03 = @CurrentCommand03 + 'NO_CHECKSUM'

          IF @Version >= 10
          BEGIN
            SET @CurrentCommand03 = @CurrentCommand03 + CASE WHEN @Compress = 'Y' AND (@CurrentIsEncrypted = 0 OR (@CurrentIsEncrypted = 1 AND @Version >= 13 AND @MaxTransferSize > 65536)) THEN ', COMPRESSION' ELSE ', NO_COMPRESSION' END
          END

          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand03 = @CurrentCommand03 + ', DIFFERENTIAL'

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand03 = @CurrentCommand03 + ', FORMAT'
          END

          IF @CopyOnly = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand03 = @CurrentCommand03 + ', NORECOVERY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''
          IF @Encrypt = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + ', ENCRYPTION (ALGORITHM = ' + UPPER(@EncryptionAlgorithm) + ', '
          IF @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + 'SERVER CERTIFICATE = ' + QUOTENAME(@ServerCertificate)
          IF @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + 'SERVER ASYMMETRIC KEY = ' + QUOTENAME(@ServerAsymmetricKey)
          IF @Encrypt = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + ')'
          IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SELECT @CurrentCommandType03 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'xp_backup_database'
          WHEN @CurrentBackupType = 'LOG' THEN 'xp_backup_log'
          END

          SELECT @CurrentCommand03 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_backup_database @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          WHEN @CurrentBackupType = 'LOG' THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_backup_log @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          END

          SELECT @CurrentCommand03 = @CurrentCommand03 + ', @filename = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SELECT @CurrentCommand03 = @CurrentCommand03 + ', @mirror = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand03 = @CurrentCommand03 + ', @with = '''
          IF @CheckSum = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand03 = @CurrentCommand03 + 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand03 = @CurrentCommand03 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand03 = @CurrentCommand03 + ', NORECOVERY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          SET @CurrentCommand03 = @CurrentCommand03 + ''''
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand03 = @CurrentCommand03 + ', @read_write_filegroups = 1'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @buffercount = ' + CAST(@BufferCount AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @maxtransfersize = ' + CAST(@MaxTransferSize AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Throttle IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @throttle = ' + CAST(@Throttle AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @cryptlevel = ' + CASE
          WHEN @EncryptionAlgorithm = 'RC2_40' THEN '0'
          WHEN @EncryptionAlgorithm = 'RC2_56' THEN '1'
          WHEN @EncryptionAlgorithm = 'RC2_112' THEN '2'
          WHEN @EncryptionAlgorithm = 'RC2_128' THEN '3'
          WHEN @EncryptionAlgorithm = 'TRIPLE_DES_3KEY' THEN '4'
          WHEN @EncryptionAlgorithm = 'RC4_128' THEN '5'
          WHEN @EncryptionAlgorithm = 'AES_128' THEN '6'
          WHEN @EncryptionAlgorithm = 'AES_192' THEN '7'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN '8'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand03 = @CurrentCommand03 + ' IF @ReturnCode <> 0 RAISERROR(''Error performing LiteSpeed backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentCommandType03 = 'sqlbackup'

          SELECT @CurrentCommand03 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand03 = @CurrentCommand03 + ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand03 = @CurrentCommand03 + ' TO'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SET @CurrentCommand03 = @CurrentCommand03 + ' WITH '

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand03 = @CurrentCommand03 + ' MIRRORFILE' + ' = N''' + REPLACE((SELECT FilePath FROM @CurrentFiles WHERE Mirror = 1),'''','''''') + ''', '
          END

          IF @CheckSum = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand03 = @CurrentCommand03 + 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand03 = @CurrentCommand03 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand03 = @CurrentCommand03 + ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand03 = @CurrentCommand03 + ', NORECOVERY'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', COMPRESSION = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', THREADCOUNT = ' + CAST(@Threads AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', KEYSIZE = ' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN '128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN '256'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand03 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand03,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLBackup backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentCommandType03 = 'xp_ss_backup'

          SET @CurrentCommand03 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_backup @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

          SELECT @CurrentCommand03 = @CurrentCommand03 + ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SELECT @CurrentCommand03 = @CurrentCommand03 + ', @mirrorfile = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 1
          ORDER BY FilePath ASC

          SET @CurrentCommand03 = @CurrentCommand03 + ', @backuptype = ' + CASE WHEN @CurrentBackupType = 'FULL' THEN '''Full''' WHEN @CurrentBackupType = 'DIFF' THEN '''Differential''' WHEN @CurrentBackupType = 'LOG' THEN '''Log''' END
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand03 = @CurrentCommand03 + ', @readwritefilegroups = 1'
          SET @CurrentCommand03 = @CurrentCommand03 + ', @checksum = ' + CASE WHEN @CheckSum = 'Y' THEN '1' WHEN @CheckSum = 'N' THEN '0' END
          SET @CurrentCommand03 = @CurrentCommand03 + ', @copyonly = ' + CASE WHEN @CopyOnly = 'Y' THEN '1' WHEN @CopyOnly = 'N' THEN '0' END
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @encryptiontype = N''' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN 'AES128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN 'AES256'
          END + ''''

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @encryptedbackuppassword = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand03 = @CurrentCommand03 + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLsafe backup.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput03 = [dbo].[CommandExecute] @Command = @CurrentCommand03, @CommandType = @CurrentCommandType03, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput03 = @Error
        IF @CurrentCommandOutput03 <> 0 SET @ReturnCode = @CurrentCommandOutput03
      END

      -- Verify the backup
      IF @CurrentCommandOutput03 = 0 AND @Verify = 'Y'
      BEGIN
      WHILE EXISTS (SELECT * FROM @CurrentBackupSet WHERE VerifyCompleted = 0)
        BEGIN
          SELECT TOP 1 @CurrentBackupSetID = ID,
                       @CurrentIsMirror = Mirror
          FROM @CurrentBackupSet
          WHERE VerifyCompleted = 0
          ORDER BY ID ASC

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentCommandType04 = 'RESTORE_VERIFYONLY'

            SET @CurrentCommand04 = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand04 = @CurrentCommand04 + ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand04 = @CurrentCommand04 + ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand04 = @CurrentCommand04 + 'NO_CHECKSUM'
            IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand04 = @CurrentCommand04 + ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentCommandType04 = 'xp_restore_verifyonly'

            SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_restore_verifyonly'

            SELECT @CurrentCommand04 = @CurrentCommand04 + ' @filename = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand04 = @CurrentCommand04 + ', @with = '''
            IF @CheckSum = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand04 = @CurrentCommand04 + 'NO_CHECKSUM'
            SET @CurrentCommand04 = @CurrentCommand04 + ''''
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand04 = @CurrentCommand04 + ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand04 = @CurrentCommand04 + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying LiteSpeed backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentCommandType04 = 'sqlbackup'

            SET @CurrentCommand04 = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand04 = @CurrentCommand04 + ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand04 = @CurrentCommand04 + ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand04 = @CurrentCommand04 + 'NO_CHECKSUM'
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand04 = @CurrentCommand04 + ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand04,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLBackup backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentCommandType04 = 'xp_ss_verify'

            SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_verify @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

            SELECT @CurrentCommand04 = @CurrentCommand04 + ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand04 = @CurrentCommand04 + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLsafe backup.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput04 = [dbo].[CommandExecute] @Command = @CurrentCommand04, @CommandType = @CurrentCommandType04, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput04 = @Error
          IF @CurrentCommandOutput04 <> 0 SET @ReturnCode = @CurrentCommandOutput04

          UPDATE @CurrentBackupSet
          SET VerifyCompleted = 1,
              VerifyOutput = @CurrentCommandOutput04
          WHERE ID = @CurrentBackupSetID

          SET @CurrentBackupSetID = NULL
          SET @CurrentIsMirror = NULL

          SET @CurrentCommand04 = NULL

          SET @CurrentCommandOutput04 = NULL

          SET @CurrentCommandType04 = NULL
        END
      END

      IF @CleanupMode = 'AFTER_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),GETDATE()), 0

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 0 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 0 OR Mirror IS NULL)),
              CleanupMode = 'AFTER_BACKUP'
          WHERE Mirror = 0
        END
      END

      IF @MirrorCleanupMode = 'AFTER_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@MirrorCleanupTime),GETDATE()), 1

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 1 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 1 OR Mirror IS NULL)),
              CleanupMode = 'AFTER_BACKUP'
          WHERE Mirror = 1
        END
      END

      -- Delete old backup files, after backup
      IF ((@CurrentCommandOutput03 = 0 AND @Verify = 'N')
      OR (@CurrentCommandOutput03 = 0 AND @Verify = 'Y' AND NOT EXISTS (SELECT * FROM @CurrentBackupSet WHERE VerifyOutput <> 0 OR VerifyOutput IS NULL)))
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE EXISTS (SELECT * FROM @CurrentDirectories WHERE CleanupDate IS NOT NULL AND CleanupMode = 'AFTER_BACKUP' AND CleanupCompleted = 0)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentCommandType05 = 'xp_delete_file'

            SET @CurrentCommand05 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentCommandType05 = 'xp_slssqlmaint'

            SET @CurrentCommand05 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentCommandType05 = 'sqbutility'

            SET @CurrentCommand05 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentCommandType05 = 'xp_ss_delete'

            SET @CurrentCommand05 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput05 = [dbo].[CommandExecute] @Command = @CurrentCommand05, @CommandType = @CurrentCommandType05, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput05 = @Error
          IF @CurrentCommandOutput05 <> 0 SET @ReturnCode = @CurrentCommandOutput05

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput05
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentCommand05 = NULL

          SET @CurrentCommandOutput05 = NULL

          SET @CurrentCommandType05 = NULL
        END
      END
    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE Selected = 1
    AND Completed = 0
    AND ID = @CurrentDBID

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentBackupType = NULL
    SET @CurrentFileExtension = NULL
    SET @CurrentFileNumber = NULL
    SET @CurrentDifferentialBaseLSN = NULL
    SET @CurrentDifferentialBaseIsSnapshot = NULL
    SET @CurrentLogLSN = NULL
    SET @CurrentLatestBackup = NULL
    SET @CurrentDatabaseNameFS = NULL
    SET @CurrentDate = NULL
    SET @CurrentCleanupDate = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentAvailabilityGroupBackupPreference = NULL
    SET @CurrentIsPreferredBackupReplica = NULL
    SET @CurrentDatabaseMirroringRole = NULL
    SET @CurrentLogShippingRole = NULL
    SET @CurrentIsEncrypted = NULL
    SET @CurrentIsReadOnly = NULL

    SET @CurrentCommand03 = NULL
    SET @CurrentCommand06 = NULL

    SET @CurrentCommandOutput03 = NULL

    SET @CurrentCommandType03 = NULL

    DELETE FROM @CurrentDirectories
    DELETE FROM @CurrentFiles
    DELETE FROM @CurrentCleanupDates
    DELETE FROM @CurrentBackupSet

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END


GO
/****** Object:  StoredProcedure [dbo].[DatabaseIntegrityCheck]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseIntegrityCheck]

@Databases nvarchar(max) = NULL,
@CheckCommands nvarchar(max) = 'CHECKDB',
@PhysicalOnly nvarchar(max) = 'N',
@NoIndex nvarchar(max) = 'N',
@ExtendedLogicalChecks nvarchar(max) = 'N',
@TabLock nvarchar(max) = 'N',
@FileGroups nvarchar(max) = NULL,
@Objects nvarchar(max) = NULL,
@MaxDOP int = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@AvailabilityGroupReplicas nvarchar(max) = 'ALL',
@Updateability nvarchar(max) = 'ALL',
@LockTimeout int = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: https://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)
  DECLARE @AmazonRDS bit

  DECLARE @Cluster nvarchar(max)

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)
  DECLARE @CurrentIsReadOnly bit

  DECLARE @CurrentFGID int
  DECLARE @CurrentFileGroupID int
  DECLARE @CurrentFileGroupName nvarchar(max)
  DECLARE @CurrentFileGroupExists bit

  DECLARE @CurrentOID int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentObjectExists bit

  DECLARE @CurrentCommand01 nvarchar(max)
  DECLARE @CurrentCommand02 nvarchar(max)
  DECLARE @CurrentCommand03 nvarchar(max)
  DECLARE @CurrentCommand04 nvarchar(max)
  DECLARE @CurrentCommand05 nvarchar(max)
  DECLARE @CurrentCommand06 nvarchar(max)
  DECLARE @CurrentCommand07 nvarchar(max)
  DECLARE @CurrentCommand08 nvarchar(max)
  DECLARE @CurrentCommand09 nvarchar(max)

  DECLARE @CurrentCommandOutput01 int
  DECLARE @CurrentCommandOutput04 int
  DECLARE @CurrentCommandOutput05 int
  DECLARE @CurrentCommandOutput08 int
  DECLARE @CurrentCommandOutput09 int

  DECLARE @CurrentCommandType01 nvarchar(max)
  DECLARE @CurrentCommandType04 nvarchar(max)
  DECLARE @CurrentCommandType05 nvarchar(max)
  DECLARE @CurrentCommandType08 nvarchar(max)
  DECLARE @CurrentCommandType09 nvarchar(max)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               [Snapshot] bit,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max), AvailabilityGroupName nvarchar(max))

  DECLARE @tmpFileGroups TABLE (ID int IDENTITY,
                                FileGroupID int,
                                FileGroupName nvarchar(max),
                                Selected bit,
                                Completed bit,
                                PRIMARY KEY(Selected, Completed, ID))

  DECLARE @tmpObjects TABLE (ID int IDENTITY,
                             SchemaID int,
                             SchemaName nvarchar(max),
                             ObjectID int,
                             ObjectName nvarchar(max),
                             ObjectType nvarchar(max),
                             Selected bit,
                             Completed bit,
                             PRIMARY KEY(Selected, Completed, ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             Selected bit)

  DECLARE @SelectedFileGroups TABLE (DatabaseName nvarchar(max),
                                     FileGroupName nvarchar(max),
                                     Selected bit)

  DECLARE @SelectedObjects TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  Selected bit)

  DECLARE @SelectedCheckCommands TABLE (CheckCommand nvarchar(max))

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  SET @AmazonRDS = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CheckCommands = ' + ISNULL('''' + REPLACE(@CheckCommands,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @PhysicalOnly = ' + ISNULL('''' + REPLACE(@PhysicalOnly,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @NoIndex = ' + ISNULL('''' + REPLACE(@NoIndex,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ExtendedLogicalChecks = ' + ISNULL('''' + REPLACE(@ExtendedLogicalChecks,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @TabLock = ' + ISNULL('''' + REPLACE(@TabLock,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FileGroups = ' + ISNULL('''' + REPLACE(@FileGroups,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Objects = ' + ISNULL('''' + REPLACE(@Objects,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @AvailabilityGroupReplicas = ' + ISNULL('''' + REPLACE(@AvailabilityGroupReplicas,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: https://ola.hallengren.com' + CHAR(13) + CHAR(10)
  SET @StartMessage = REPLACE(@StartMessage,'%','%%') + ' '
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND (OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%' OR OBJECT_DEFINITION(objects.[object_id]) LIKE '%LOCK_TIMEOUT%'))
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF SERVERPROPERTY('EngineEdition') = 5 AND @Version < 12
  BEGIN
    SET @ErrorMessage = 'The stored procedure DatabaseIntegrityCheck is not supported on this version of Azure SQL Database.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(', ',@Databases) > 0 SET @Databases = REPLACE(@Databases,', ',',')
  WHILE CHARINDEX(' ,',@Databases) > 0 SET @Databases = REPLACE(@Databases,' ,',',')

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('EngineEdition') <> 5
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Snapshot], Selected, Completed)
    SELECT [name] AS DatabaseName,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           CASE WHEN name IN (SELECT availability_databases_cluster.database_name FROM sys.availability_databases_cluster availability_databases_cluster) THEN 1 ELSE 0 END AS AvailabilityGroup,
           CASE WHEN source_database_id IS NOT NULL THEN 1 ELSE 0 END AS [Snapshot],
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    ORDER BY [name] ASC
  END
  ELSE
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Snapshot], Selected, Completed)
    SELECT [name] AS DatabaseName,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           NULL AS AvailabilityGroup,
           CASE WHEN source_database_id IS NOT NULL THEN 1 ELSE 0 END AS [Snapshot],
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    ORDER BY [name] ASC
  END

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  AND NOT ((tmpDatabases.DatabaseName = 'tempdb' OR tmpDatabases.[Snapshot] = 1) AND tmpDatabases.DatabaseName <> SelectedDatabases.DatabaseName)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  AND NOT ((tmpDatabases.DatabaseName = 'tempdb' OR tmpDatabases.[Snapshot] = 1) AND tmpDatabases.DatabaseName <> SelectedDatabases.DatabaseName)
  WHERE SelectedDatabases.Selected = 0

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(', ',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,', ',',')
    WHILE CHARINDEX(' ,',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,' ,',',')

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT AvailabilityGroupName, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT availability_databases_cluster.database_name, availability_groups.name
    FROM sys.availability_databases_cluster availability_databases_cluster
    INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id

    UPDATE tmpDatabases
    SET Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @AvailabilityGroups is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    SET @ErrorMessage = 'You need to specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'You can only specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select filegroups                                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET @FileGroups = REPLACE(@FileGroups, CHAR(10), '')
  SET @FileGroups = REPLACE(@FileGroups, CHAR(13), '')

  WHILE CHARINDEX(', ',@FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups,', ',',')
  WHILE CHARINDEX(' ,',@FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups,' ,',',')

  SET @FileGroups = LTRIM(RTRIM(@FileGroups));

  WITH FileGroups1 (StartPosition, EndPosition, FileGroupItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FileGroups, 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, 1, ISNULL(NULLIF(CHARINDEX(',', @FileGroups, 1), 0), LEN(@FileGroups) + 1) - 1) AS FileGroupItem
  WHERE @FileGroups IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) - EndPosition - 1) AS FileGroupItem
  FROM FileGroups1
  WHERE EndPosition < LEN(@FileGroups) + 1
  ),
  FileGroups2 (FileGroupItem, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem LIKE '-%' THEN RIGHT(FileGroupItem,LEN(FileGroupItem) - 1) ELSE FileGroupItem END AS FileGroupItem,
         CASE WHEN FileGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM FileGroups1
  ),
  FileGroups3 (FileGroupItem, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem = 'ALL_FILEGROUPS' THEN '%.%' ELSE FileGroupItem END AS FileGroupItem,
         Selected
  FROM FileGroups2
  ),
  FileGroups4 (DatabaseName, FileGroupName, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,2) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,1) ELSE NULL END AS FileGroupName,
         Selected
  FROM FileGroups3
  )
  INSERT INTO @SelectedFileGroups (DatabaseName, FileGroupName, Selected)
  SELECT DatabaseName, FileGroupName, Selected
  FROM FileGroups4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select objects                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Objects = REPLACE(@Objects, CHAR(10), '')
  SET @Objects = REPLACE(@Objects, CHAR(13), '')

  WHILE CHARINDEX(', ',@Objects) > 0 SET @Objects = REPLACE(@Objects,', ',',')
  WHILE CHARINDEX(' ,',@Objects) > 0 SET @Objects = REPLACE(@Objects,' ,',',')

  SET @Objects = LTRIM(RTRIM(@Objects));

  WITH Objects1 (StartPosition, EndPosition, ObjectItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Objects, 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, 1, ISNULL(NULLIF(CHARINDEX(',', @Objects, 1), 0), LEN(@Objects) + 1) - 1) AS ObjectItem
  WHERE @Objects IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) - EndPosition - 1) AS ObjectItem
  FROM Objects1
  WHERE EndPosition < LEN(@Objects) + 1
  ),
  Objects2 (ObjectItem, Selected) AS
  (
  SELECT CASE WHEN ObjectItem LIKE '-%' THEN RIGHT(ObjectItem,LEN(ObjectItem) - 1) ELSE ObjectItem END AS ObjectItem,
         CASE WHEN ObjectItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Objects1
  ),
  Objects3 (ObjectItem, Selected) AS
  (
  SELECT CASE WHEN ObjectItem = 'ALL_OBJECTS' THEN '%.%.%' ELSE ObjectItem END AS ObjectItem,
         Selected
  FROM Objects2
  ),
  Objects4 (DatabaseName, SchemaName, ObjectName, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,3) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,2) ELSE NULL END AS SchemaName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,1) ELSE NULL END AS ObjectName,
         Selected
  FROM Objects3
  )
  INSERT INTO @SelectedObjects (DatabaseName, SchemaName, ObjectName, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, Selected
  FROM Objects4
  OPTION (MAXRECURSION 0);

  ----------------------------------------------------------------------------------------------------
  --// Select check commands                                                                      //--
  ----------------------------------------------------------------------------------------------------

  WITH CheckCommands (StartPosition, EndPosition, CheckCommand) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, 1, ISNULL(NULLIF(CHARINDEX(',', @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) - 1) AS CheckCommand
  WHERE @CheckCommands IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) - EndPosition - 1) AS CheckCommand
  FROM CheckCommands
  WHERE EndPosition < LEN(@CheckCommands) + 1
  )
  INSERT INTO @SelectedCheckCommands (CheckCommand)
  SELECT CheckCommand
  FROM CheckCommands
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand NOT IN('CHECKDB','CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG')) OR EXISTS (SELECT * FROM @SelectedCheckCommands GROUP BY CheckCommand HAVING COUNT(*) > 1) OR NOT EXISTS (SELECT * FROM @SelectedCheckCommands) OR (EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKDB')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG'))) OR (EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKALLOC','CHECKTABLE')))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @CheckCommands is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PhysicalOnly NOT IN ('Y','N') OR @PhysicalOnly IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @PhysicalOnly is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @NoIndex NOT IN ('Y','N') OR @NoIndex IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @NoIndex is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @ExtendedLogicalChecks NOT IN ('Y','N') OR @ExtendedLogicalChecks IS NULL OR (@ExtendedLogicalChecks = 'Y' AND NOT @Version >= 10) OR (@PhysicalOnly = 'Y' AND @ExtendedLogicalChecks = 'Y')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @ExtendedLogicalChecks is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @TabLock NOT IN ('Y','N') OR @TabLock IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @TabLock is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS(SELECT * FROM @SelectedFileGroups WHERE DatabaseName IS NULL OR FileGroupName IS NULL) OR (@FileGroups IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedFileGroups)) OR (@FileGroups IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP'))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FileGroups is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS(SELECT * FROM @SelectedObjects WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL) OR (@Objects IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedObjects)) OR (@Objects IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE'))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Objects is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxDOP < 0 OR @MaxDOP > 64 OR (@MaxDOP > 1 AND SERVERPROPERTY('EngineEdition') NOT IN (3,5)) OR (@MaxDOP IS NOT NULL AND @Version < 12.050000)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MaxDOP is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @AvailabilityGroupReplicas NOT IN('ALL','PRIMARY','SECONDARY') OR @AvailabilityGroupReplicas IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @AvailabilityGroupReplicas is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Updateability is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LockTimeout < 0
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LockTimeout is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available at https://ola.hallengren.com/sql-server-integrity-check.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Check Availability Group cluster name                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Version >= 11 AND SERVERPROPERTY('EngineEdition') <> 5
  BEGIN
    SELECT @Cluster = cluster_name
    FROM sys.dm_hadr_cluster
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Selected = 1 AND Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentDBID = ID,
                 @CurrentDatabaseName = DatabaseName
    FROM @tmpDatabases
    WHERE Selected = 1
    AND Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND @Cluster IS NOT NULL
    BEGIN
      SELECT @CurrentAvailabilityGroup = availability_groups.name,
             @CurrentAvailabilityGroupRole = dm_hadr_availability_replica_states.role_desc
      FROM sys.databases databases
      INNER JOIN sys.availability_databases_cluster availability_databases_cluster ON databases.group_database_id = availability_databases_cluster.group_database_id
      INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id
      INNER JOIN sys.dm_hadr_availability_replica_states dm_hadr_availability_replica_states ON availability_groups.group_id = dm_hadr_availability_replica_states.group_id AND databases.replica_id = dm_hadr_availability_replica_states.replica_id
      WHERE databases.name = @CurrentDatabaseName
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = @CurrentDatabaseID
    END

    SELECT @CurrentIsReadOnly = is_read_only
    FROM sys.databases
    WHERE name = @CurrentDatabaseName

    -- Set database message
    SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    IF @CurrentIsDatabaseAccessible IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group: ' + @CurrentAvailabilityGroup + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group role: ' + @CurrentAvailabilityGroupRole + CHAR(13) + CHAR(10)
    IF @CurrentDatabaseMirroringRole IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Database mirroring role: ' + @CurrentDatabaseMirroringRole + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%') + ' '
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND (@CurrentIsDatabaseAccessible = 1 OR @CurrentIsDatabaseAccessible IS NULL)
    AND (@CurrentAvailabilityGroupRole = @AvailabilityGroupReplicas OR @AvailabilityGroupReplicas = 'ALL' OR @CurrentAvailabilityGroupRole IS NULL)
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    BEGIN

      -- Check database
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKDB')
      BEGIN
        SET @CurrentCommandType01 = 'DBCC_CHECKDB'

        SET @CurrentCommand01 = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand01 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand01 = @CurrentCommand01 + 'DBCC CHECKDB (' + QUOTENAME(@CurrentDatabaseName)
        IF @NoIndex = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', NOINDEX'
        SET @CurrentCommand01 = @CurrentCommand01 + ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @PhysicalOnly = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ', DATA_PURITY'
        IF @PhysicalOnly = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', PHYSICAL_ONLY'
        IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', EXTENDED_LOGICAL_CHECKS'
        IF @TabLock = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', TABLOCK'
        IF @MaxDOP IS NOT NULL SET @CurrentCommand01 = @CurrentCommand01 + ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

        EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @Command = @CurrentCommand01, @CommandType = @CurrentCommandType01, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
        IF @CurrentCommandOutput01 <> 0 SET @ReturnCode = @CurrentCommandOutput01
      END

      -- Check filegroups
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP')
      BEGIN
        SET @CurrentCommand02 = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT data_space_id AS FileGroupID, name AS FileGroupName, 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups WHERE [type] <> ''FX'' ORDER BY CASE WHEN filegroups.name = ''PRIMARY'' THEN 1 ELSE 0 END DESC, filegroups.name ASC'

        INSERT INTO @tmpFileGroups (FileGroupID, FileGroupName, Selected, Completed)
        EXECUTE sp_executesql @statement = @CurrentCommand02
        SET @Error = @@ERROR
        IF @Error <> 0 SET @ReturnCode = @Error

        IF @FileGroups IS NULL
        BEGIN
          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = 1
          FROM @tmpFileGroups tmpFileGroups
        END
        ELSE
        BEGIN
          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = SelectedFileGroups.Selected
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN @SelectedFileGroups SelectedFileGroups
          ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
          WHERE SelectedFileGroups.Selected = 1

          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = SelectedFileGroups.Selected
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN @SelectedFileGroups SelectedFileGroups
          ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
          WHERE SelectedFileGroups.Selected = 0
        END

        WHILE EXISTS (SELECT * FROM @tmpFileGroups WHERE Selected = 1 AND Completed = 0)
        BEGIN
          SELECT TOP 1 @CurrentFGID = ID,
                       @CurrentFileGroupID = FileGroupID,
                       @CurrentFileGroupName = FileGroupName
          FROM @tmpFileGroups
          WHERE Selected = 1
          AND Completed = 0
          ORDER BY ID ASC

          -- Does the filegroup exist?
          SET @CurrentCommand03 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand03 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand03 = @CurrentCommand03 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups WHERE [type] <> ''FX'' AND filegroups.data_space_id = @ParamFileGroupID AND filegroups.[name] = @ParamFileGroupName) BEGIN SET @ParamFileGroupExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand03, @params = N'@ParamFileGroupID int, @ParamFileGroupName sysname, @ParamFileGroupExists bit OUTPUT', @ParamFileGroupID = @CurrentFileGroupID, @ParamFileGroupName = @CurrentFileGroupName, @ParamFileGroupExists = @CurrentFileGroupExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentFileGroupExists IS NULL SET @CurrentFileGroupExists = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The file group ' + QUOTENAME(@CurrentFileGroupName) + ' in the database ' + QUOTENAME(@CurrentDatabaseName) + ' is locked. It could not be checked if the filegroup exists.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
          END

          IF @CurrentFileGroupExists = 1
          BEGIN
            SET @CurrentCommandType04 = 'DBCC_CHECKFILEGROUP'

            SET @CurrentCommand04 = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand04 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand04 = @CurrentCommand04 + 'USE ' + QUOTENAME(@CurrentDatabaseName) + '; DBCC CHECKFILEGROUP (' + QUOTENAME(@CurrentFileGroupName)
            IF @NoIndex = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + ', NOINDEX'
            SET @CurrentCommand04 = @CurrentCommand04 + ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + ', PHYSICAL_ONLY'
            IF @TabLock = 'Y' SET @CurrentCommand04 = @CurrentCommand04 + ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand04 = @CurrentCommand04 + ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput04 = [dbo].[CommandExecute] @Command = @CurrentCommand04, @CommandType = @CurrentCommandType04, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput04 = @Error
            IF @CurrentCommandOutput04 <> 0 SET @ReturnCode = @CurrentCommandOutput04
          END

          UPDATE @tmpFileGroups
          SET Completed = 1
          WHERE Selected = 1
          AND Completed = 0
          AND ID = @CurrentFGID

          SET @CurrentFGID = NULL
          SET @CurrentFileGroupID = NULL
          SET @CurrentFileGroupName = NULL
          SET @CurrentFileGroupExists = NULL

          SET @CurrentCommand03 = NULL
          SET @CurrentCommand04 = NULL

          SET @CurrentCommandOutput04 = NULL

          SET @CurrentCommandType04 = NULL
        END
      END

      -- Check disk space allocation structures
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKALLOC')
      BEGIN
        SET @CurrentCommandType05 = 'DBCC_CHECKALLOC'

        SET @CurrentCommand05 = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand05 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand05 = @CurrentCommand05 + 'DBCC CHECKALLOC (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand05 = @CurrentCommand05 + ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @TabLock = 'Y' SET @CurrentCommand05 = @CurrentCommand05 + ', TABLOCK'

        EXECUTE @CurrentCommandOutput05 = [dbo].[CommandExecute] @Command = @CurrentCommand05, @CommandType = @CurrentCommandType05, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput05 = @Error
        IF @CurrentCommandOutput05 <> 0 SET @ReturnCode = @CurrentCommandOutput05
      END

      -- Check objects
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE')
      BEGIN
        SET @CurrentCommand06 = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' ORDER BY schemas.name ASC, objects.name ASC'

        INSERT INTO @tmpObjects (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, Selected, Completed)
        EXECUTE sp_executesql @statement = @CurrentCommand06
        SET @Error = @@ERROR
        IF @Error <> 0 SET @ReturnCode = @Error

        IF @Objects IS NULL
        BEGIN
          UPDATE tmpObjects
          SET tmpObjects.Selected = 1
          FROM @tmpObjects tmpObjects
        END
        ELSE
        BEGIN
          UPDATE tmpObjects
          SET tmpObjects.Selected = SelectedObjects.Selected
          FROM @tmpObjects tmpObjects
          INNER JOIN @SelectedObjects SelectedObjects
          ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
          WHERE SelectedObjects.Selected = 1

          UPDATE tmpObjects
          SET tmpObjects.Selected = SelectedObjects.Selected
          FROM @tmpObjects tmpObjects
          INNER JOIN @SelectedObjects SelectedObjects
          ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
          WHERE SelectedObjects.Selected = 0
        END

        WHILE EXISTS (SELECT * FROM @tmpObjects WHERE Selected = 1 AND Completed = 0)
        BEGIN
          SELECT TOP 1 @CurrentOID = ID,
                       @CurrentSchemaID = SchemaID,
                       @CurrentSchemaName = SchemaName,
                       @CurrentObjectID = ObjectID,
                       @CurrentObjectName = ObjectName,
                       @CurrentObjectType = ObjectType
          FROM @tmpObjects
          WHERE Selected = 1
          AND Completed = 0
          ORDER BY ID ASC

          -- Does the object exist?
          SET @CurrentCommand07 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand07 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand07 = @CurrentCommand07 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType) BEGIN SET @ParamObjectExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand07, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamObjectExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamObjectExists = @CurrentObjectExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentObjectExists IS NULL SET @CurrentObjectExists = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the object exists.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
          END

          IF @CurrentObjectExists = 1
          BEGIN
            SET @CurrentCommandType08 = 'DBCC_CHECKTABLE'

            SET @CurrentCommand08 = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand08 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand08 = @CurrentCommand08 + 'USE ' + QUOTENAME(@CurrentDatabaseName) + '; DBCC CHECKTABLE (''' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ''''
            IF @NoIndex = 'Y' SET @CurrentCommand08 = @CurrentCommand08 + ', NOINDEX'
            SET @CurrentCommand08 = @CurrentCommand08 + ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @PhysicalOnly = 'N' SET @CurrentCommand08 = @CurrentCommand08 + ', DATA_PURITY'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand08 = @CurrentCommand08 + ', PHYSICAL_ONLY'
            IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand08 = @CurrentCommand08 + ', EXTENDED_LOGICAL_CHECKS'
            IF @TabLock = 'Y' SET @CurrentCommand08 = @CurrentCommand08 + ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand08 = @CurrentCommand08 + ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput08 = [dbo].[CommandExecute] @Command = @CurrentCommand08, @CommandType = @CurrentCommandType08, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput08 = @Error
            IF @CurrentCommandOutput08 <> 0 SET @ReturnCode = @CurrentCommandOutput08
          END

          UPDATE @tmpObjects
          SET Completed = 1
          WHERE Selected = 1
          AND Completed = 0
          AND ID = @CurrentOID

          SET @CurrentOID = NULL
          SET @CurrentSchemaID = NULL
          SET @CurrentSchemaName = NULL
          SET @CurrentObjectID = NULL
          SET @CurrentObjectName = NULL
          SET @CurrentObjectType = NULL
          SET @CurrentObjectExists = NULL

          SET @CurrentCommand07 = NULL
          SET @CurrentCommand08 = NULL

          SET @CurrentCommandOutput08 = NULL

          SET @CurrentCommandType08 = NULL
        END
      END

      -- Check catalog
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKCATALOG')
      BEGIN
        SET @CurrentCommandType09 = 'DBCC_CHECKCATALOG'

        SET @CurrentCommand09 = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand09 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand09 = @CurrentCommand09 + 'DBCC CHECKCATALOG (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand09 = @CurrentCommand09 + ') WITH NO_INFOMSGS'

        EXECUTE @CurrentCommandOutput09 = [dbo].[CommandExecute] @Command = @CurrentCommand09, @CommandType = @CurrentCommandType09, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput09 = @Error
        IF @CurrentCommandOutput09 <> 0 SET @ReturnCode = @CurrentCommandOutput09
      END

    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE Selected = 1
    AND Completed = 0
    AND ID = @CurrentDBID

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentDatabaseMirroringRole = NULL
    SET @CurrentIsReadOnly = NULL

    SET @CurrentCommand01 = NULL
    SET @CurrentCommand02 = NULL
    SET @CurrentCommand05 = NULL
    SET @CurrentCommand06 = NULL
    SET @CurrentCommand09 = NULL

    SET @CurrentCommandOutput01 = NULL
    SET @CurrentCommandOutput05 = NULL
    SET @CurrentCommandOutput09 = NULL

    SET @CurrentCommandType01 = NULL
    SET @CurrentCommandType05 = NULL
    SET @CurrentCommandType09 = NULL

    DELETE FROM @tmpFileGroups
    DELETE FROM @tmpObjects

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END


GO
/****** Object:  StoredProcedure [dbo].[IndexOptimize]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IndexOptimize]

@Databases nvarchar(max) = NULL,
@FragmentationLow nvarchar(max) = NULL,
@FragmentationMedium nvarchar(max) = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh nvarchar(max) = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 int = 5,
@FragmentationLevel2 int = 30,
@PageCountLevel int = 1000,
@SortInTempdb nvarchar(max) = 'N',
@MaxDOP int = NULL,
@FillFactor int = NULL,
@PadIndex nvarchar(max) = NULL,
@LOBCompaction nvarchar(max) = 'Y',
@UpdateStatistics nvarchar(max) = NULL,
@OnlyModifiedStatistics nvarchar(max) = 'N',
@StatisticsSample int = NULL,
@StatisticsResample nvarchar(max) = 'N',
@PartitionLevel nvarchar(max) = 'Y',
@MSShippedObjects nvarchar(max) = 'N',
@Indexes nvarchar(max) = NULL,
@TimeLimit int = NULL,
@Delay int = NULL,
@WaitAtLowPriorityMaxDuration int = NULL,
@WaitAtLowPriorityAbortAfterWait nvarchar(max) = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@LockTimeout int = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: https://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET ARITHABORT ON

  SET NUMERIC_ROUNDABORT OFF

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)
  DECLARE @AmazonRDS bit

  DECLARE @Cluster nvarchar(max)

  DECLARE @StartTime datetime

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)
  DECLARE @CurrentIsReadOnly bit

  DECLARE @CurrentCommand01 nvarchar(max)
  DECLARE @CurrentCommand02 nvarchar(max)
  DECLARE @CurrentCommand03 nvarchar(max)
  DECLARE @CurrentCommand04 nvarchar(max)
  DECLARE @CurrentCommand05 nvarchar(max)
  DECLARE @CurrentCommand06 nvarchar(max)
  DECLARE @CurrentCommand07 nvarchar(max)
  DECLARE @CurrentCommand08 nvarchar(max)
  DECLARE @CurrentCommand09 nvarchar(max)
  DECLARE @CurrentCommand10 nvarchar(max)
  DECLARE @CurrentCommand11 nvarchar(max)
  DECLARE @CurrentCommand12 nvarchar(max)
  DECLARE @CurrentCommand13 nvarchar(max)
  DECLARE @CurrentCommand14 nvarchar(max)

  DECLARE @CurrentCommandOutput13 int
  DECLARE @CurrentCommandOutput14 int

  DECLARE @CurrentCommandType13 nvarchar(max)
  DECLARE @CurrentCommandType14 nvarchar(max)

  DECLARE @CurrentIxID int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentIsMemoryOptimized bit
  DECLARE @CurrentIndexID int
  DECLARE @CurrentIndexName nvarchar(max)
  DECLARE @CurrentIndexType int
  DECLARE @CurrentStatisticsID int
  DECLARE @CurrentStatisticsName nvarchar(max)
  DECLARE @CurrentPartitionID bigint
  DECLARE @CurrentPartitionNumber int
  DECLARE @CurrentPartitionCount int
  DECLARE @CurrentIsPartition bit
  DECLARE @CurrentIndexExists bit
  DECLARE @CurrentStatisticsExists bit
  DECLARE @CurrentIsImageText bit
  DECLARE @CurrentIsNewLOB bit
  DECLARE @CurrentIsFileStream bit
  DECLARE @CurrentIsColumnStore bit
  DECLARE @CurrentAllowPageLocks bit
  DECLARE @CurrentNoRecompute bit
  DECLARE @CurrentStatisticsModified bit
  DECLARE @CurrentOnReadOnlyFileGroup bit
  DECLARE @CurrentFragmentationLevel float
  DECLARE @CurrentPageCount bigint
  DECLARE @CurrentFragmentationGroup nvarchar(max)
  DECLARE @CurrentAction nvarchar(max)
  DECLARE @CurrentMaxDOP int
  DECLARE @CurrentUpdateStatistics nvarchar(max)
  DECLARE @CurrentStatisticsSample int
  DECLARE @CurrentStatisticsResample nvarchar(max)
  DECLARE @CurrentComment nvarchar(max)
  DECLARE @CurrentExtendedInfo xml
  DECLARE @CurrentDelay datetime

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max), AvailabilityGroupName nvarchar(max))

  DECLARE @tmpIndexesStatistics TABLE (ID int IDENTITY,
                                       SchemaID int,
                                       SchemaName nvarchar(max),
                                       ObjectID int,
                                       ObjectName nvarchar(max),
                                       ObjectType nvarchar(max),
                                       IsMemoryOptimized bit,
                                       IndexID int,
                                       IndexName nvarchar(max),
                                       IndexType int,
                                       StatisticsID int,
                                       StatisticsName nvarchar(max),
                                       PartitionID bigint,
                                       PartitionNumber int,
                                       PartitionCount int,
                                       Selected bit,
                                       Completed bit,
                                       PRIMARY KEY(Selected, Completed, ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             Selected bit)

  DECLARE @SelectedIndexes TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  IndexName nvarchar(max),
                                  Selected bit)

  DECLARE @Actions TABLE ([Action] nvarchar(max))

  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')

  DECLARE @ActionsPreferred TABLE (FragmentationGroup nvarchar(max),
                                   [Priority] int,
                                   [Action] nvarchar(max))

  DECLARE @CurrentActionsAllowed TABLE ([Action] nvarchar(max))

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  SET @AmazonRDS = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = CONVERT(datetime,CONVERT(nvarchar,GETDATE(),120),120)

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLow = ' + ISNULL('''' + REPLACE(@FragmentationLow,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationMedium = ' + ISNULL('''' + REPLACE(@FragmentationMedium,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationHigh = ' + ISNULL('''' + REPLACE(@FragmentationHigh,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @PageCountLevel = ' + ISNULL(CAST(@PageCountLevel AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @SortInTempdb = ' + ISNULL('''' + REPLACE(@SortInTempdb,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @FillFactor = ' + ISNULL(CAST(@FillFactor AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @PadIndex = ' + ISNULL('''' + REPLACE(@PadIndex,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LOBCompaction = ' + ISNULL('''' + REPLACE(@LOBCompaction,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @UpdateStatistics = ' + ISNULL('''' + REPLACE(@UpdateStatistics,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @OnlyModifiedStatistics = ' + ISNULL('''' + REPLACE(@OnlyModifiedStatistics,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @StatisticsSample = ' + ISNULL(CAST(@StatisticsSample AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @StatisticsResample = ' + ISNULL('''' + REPLACE(@StatisticsResample,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @PartitionLevel = ' + ISNULL('''' + REPLACE(@PartitionLevel,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MSShippedObjects = ' + ISNULL('''' + REPLACE(@MSShippedObjects,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Indexes = ' + ISNULL('''' + REPLACE(@Indexes,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Delay = ' + ISNULL(CAST(@Delay AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @WaitAtLowPriorityMaxDuration = ' + ISNULL(CAST(@WaitAtLowPriorityMaxDuration AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @WaitAtLowPriorityAbortAfterWait = ' + ISNULL('''' + REPLACE(@WaitAtLowPriorityAbortAfterWait,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: https://ola.hallengren.com' + CHAR(13) + CHAR(10)
  SET @StartMessage = REPLACE(@StartMessage,'%','%%') + ' '
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND (OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%' OR OBJECT_DEFINITION(objects.[object_id]) LIKE '%LOCK_TIMEOUT%'))
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF SERVERPROPERTY('EngineEdition') = 5 AND @Version < 12
  BEGIN
    SET @ErrorMessage = 'The stored procedure IndexOptimize is not supported on this version of Azure SQL Database.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(', ',@Databases) > 0 SET @Databases = REPLACE(@Databases,', ',',')
  WHILE CHARINDEX(' ,',@Databases) > 0 SET @Databases = REPLACE(@Databases,' ,',',')

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('EngineEdition') <> 5
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, Selected, Completed)
    SELECT [name] AS DatabaseName,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           CASE WHEN name IN (SELECT availability_databases_cluster.database_name FROM sys.availability_databases_cluster availability_databases_cluster) THEN 1 ELSE 0 END AS AvailabilityGroup,
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    WHERE [name] <> 'tempdb'
    AND source_database_id IS NULL
    ORDER BY [name] ASC
  END
  ELSE
  BEGIN
    INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, Selected, Completed)
    SELECT [name] AS DatabaseName,
           CASE WHEN name IN('master','msdb','model') THEN 'S' ELSE 'U' END AS DatabaseType,
           NULL AS AvailabilityGroup,
           0 AS Selected,
           0 AS Completed
    FROM sys.databases
    WHERE [name] <> 'tempdb'
    AND source_database_id IS NULL
    ORDER BY [name] ASC
  END

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 0

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(', ',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,', ',',')
    WHILE CHARINDEX(' ,',@AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups,' ,',',')

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT AvailabilityGroupName, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT availability_databases_cluster.database_name, availability_groups.name
    FROM sys.availability_databases_cluster availability_databases_cluster
    INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id

    UPDATE tmpDatabases
    SET Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @AvailabilityGroups is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    SET @ErrorMessage = 'You need to specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'You can only specify one of the parameters @Databases and @AvailabilityGroups.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select indexes                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Indexes = REPLACE(@Indexes, CHAR(10), '')
  SET @Indexes = REPLACE(@Indexes, CHAR(13), '')

  WHILE CHARINDEX(', ',@Indexes) > 0 SET @Indexes = REPLACE(@Indexes,', ',',')
  WHILE CHARINDEX(' ,',@Indexes) > 0 SET @Indexes = REPLACE(@Indexes,' ,',',')

  SET @Indexes = LTRIM(RTRIM(@Indexes));

  WITH Indexes1 (StartPosition, EndPosition, IndexItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Indexes, 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, 1, ISNULL(NULLIF(CHARINDEX(',', @Indexes, 1), 0), LEN(@Indexes) + 1) - 1) AS IndexItem
  WHERE @Indexes IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) - EndPosition - 1) AS IndexItem
  FROM Indexes1
  WHERE EndPosition < LEN(@Indexes) + 1
  ),
  Indexes2 (IndexItem, Selected) AS
  (
  SELECT CASE WHEN IndexItem LIKE '-%' THEN RIGHT(IndexItem,LEN(IndexItem) - 1) ELSE IndexItem END AS IndexItem,
         CASE WHEN IndexItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Indexes1
  ),
  Indexes3 (IndexItem, Selected) AS
  (
  SELECT CASE WHEN IndexItem = 'ALL_INDEXES' THEN '%.%.%.%' ELSE IndexItem END AS IndexItem,
         Selected
  FROM Indexes2
  ),
  Indexes4 (DatabaseName, SchemaName, ObjectName, IndexName, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,3) ELSE PARSENAME(IndexItem,4) END AS DatabaseName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,2) ELSE PARSENAME(IndexItem,3) END AS SchemaName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,1) ELSE PARSENAME(IndexItem,2) END AS ObjectName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN '%' ELSE PARSENAME(IndexItem,1) END AS IndexName,
         Selected
  FROM Indexes3
  )
  INSERT INTO @SelectedIndexes (DatabaseName, SchemaName, ObjectName, IndexName, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, IndexName, Selected
  FROM Indexes4
  OPTION (MAXRECURSION 0);

  ----------------------------------------------------------------------------------------------------
  --// Select actions                                                                             //--
  ----------------------------------------------------------------------------------------------------

  WITH FragmentationLow (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) - 1) AS [Action]
  WHERE @FragmentationLow IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationLow
  WHERE EndPosition < LEN(@FragmentationLow) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Low' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationLow
  OPTION (MAXRECURSION 0);

  WITH FragmentationMedium (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) - 1) AS [Action]
  WHERE @FragmentationMedium IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationMedium
  WHERE EndPosition < LEN(@FragmentationMedium) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Medium' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationMedium
  OPTION (MAXRECURSION 0);

  WITH FragmentationHigh (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) - 1) AS [Action]
  WHERE @FragmentationHigh IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(',', @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationHigh
  WHERE EndPosition < LEN(@FragmentationHigh) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'High' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationHigh
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FragmentationLow is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FragmentationMedium is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'High' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'High' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FragmentationHigh is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 >= @FragmentationLevel2 OR @FragmentationLevel1 IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FragmentationLevel1 is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 <= @FragmentationLevel1 OR @FragmentationLevel2 IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FragmentationLevel2 is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PageCountLevel < 0 OR @PageCountLevel IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @PageCountLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @SortInTempdb NOT IN('Y','N') OR @SortInTempdb IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @SortInTempdb is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxDOP < 0 OR @MaxDOP > 64 OR (@MaxDOP > 1 AND SERVERPROPERTY('EngineEdition') NOT IN (3,5))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MaxDOP is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FillFactor <= 0 OR @FillFactor > 100
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @FillFactor is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PadIndex NOT IN('Y','N')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @PadIndex is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LOBCompaction NOT IN('Y','N') OR @LOBCompaction IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LOBCompaction is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @UpdateStatistics NOT IN('ALL','COLUMNS','INDEX')
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @UpdateStatistics is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @OnlyModifiedStatistics NOT IN('Y','N') OR @OnlyModifiedStatistics IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @OnlyModifiedStatistics is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @StatisticsSample <= 0 OR @StatisticsSample  > 100
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @StatisticsSample is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @StatisticsResample NOT IN('Y','N') OR @StatisticsResample IS NULL OR (@StatisticsResample = 'Y' AND @StatisticsSample IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @StatisticsResample is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PartitionLevel NOT IN('Y','N') OR @PartitionLevel IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @PartitionLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MSShippedObjects NOT IN('Y','N') OR @MSShippedObjects IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @MSShippedObjects is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS(SELECT * FROM @SelectedIndexes WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL OR IndexName IS NULL) OR (@Indexes IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedIndexes))
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Indexes is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @TimeLimit < 0
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @TimeLimit is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Delay < 0
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Delay is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @WaitAtLowPriorityMaxDuration < 0 OR (@WaitAtLowPriorityMaxDuration IS NOT NULL AND @Version < 12) OR (@WaitAtLowPriorityMaxDuration IS NOT NULL AND @WaitAtLowPriorityAbortAfterWait IS NULL) OR (@WaitAtLowPriorityMaxDuration IS NULL AND @WaitAtLowPriorityAbortAfterWait IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @WaitAtLowPriorityAbortAfterWait NOT IN('NONE','SELF','BLOCKERS') OR (@WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @Version < 12) OR (@WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @WaitAtLowPriorityMaxDuration IS NULL) OR (@WaitAtLowPriorityAbortAfterWait IS NULL AND @WaitAtLowPriorityMaxDuration IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LockTimeout < 0
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LockTimeout is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for the parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available at https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Check Availability Group cluster name                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Version >= 11 AND SERVERPROPERTY('EngineEdition') <> 5
  BEGIN
    SELECT @Cluster = cluster_name
    FROM sys.dm_hadr_cluster
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Selected = 1 AND Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentDBID = ID,
                 @CurrentDatabaseName = DatabaseName
    FROM @tmpDatabases
    WHERE Selected = 1
    AND Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND @Cluster IS NOT NULL
    BEGIN
      SELECT @CurrentAvailabilityGroup = availability_groups.name,
             @CurrentAvailabilityGroupRole = dm_hadr_availability_replica_states.role_desc
      FROM sys.databases databases
      INNER JOIN sys.availability_databases_cluster availability_databases_cluster ON databases.group_database_id = availability_databases_cluster.group_database_id
      INNER JOIN sys.availability_groups availability_groups ON availability_databases_cluster.group_id = availability_groups.group_id
      INNER JOIN sys.dm_hadr_availability_replica_states dm_hadr_availability_replica_states ON availability_groups.group_id = dm_hadr_availability_replica_states.group_id AND databases.replica_id = dm_hadr_availability_replica_states.replica_id
      WHERE databases.name = @CurrentDatabaseName
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = @CurrentDatabaseID
    END

    SELECT @CurrentIsReadOnly = is_read_only
    FROM sys.databases
    WHERE name = @CurrentDatabaseName

    -- Set database message
    SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    IF @CurrentIsDatabaseAccessible IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group: ' + @CurrentAvailabilityGroup + CHAR(13) + CHAR(10)
    IF @CurrentAvailabilityGroup IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Availability group role: ' + @CurrentAvailabilityGroupRole + CHAR(13) + CHAR(10)
    IF @CurrentDatabaseMirroringRole IS NOT NULL SET @DatabaseMessage = @DatabaseMessage + 'Database mirroring role: ' + @CurrentDatabaseMirroringRole + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%') + ' '
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND (@CurrentIsDatabaseAccessible = 1 OR @CurrentIsDatabaseAccessible IS NULL)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') = 'READ_WRITE'
    BEGIN

      -- Select indexes in the current database
      IF (EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IS NOT NULL) AND (GETDATE() < DATEADD(ss,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand01 = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, StatisticsID, StatisticsName, PartitionID, PartitionNumber, PartitionCount, Selected, Completed FROM ('

        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX')
        BEGIN
          SET @CurrentCommand01 = @CurrentCommand01 + 'SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE 'NULL' END + ' AS IsMemoryOptimized, indexes.index_id AS IndexID, indexes.[name] AS IndexName, indexes.[type] AS IndexType, stats.stats_id AS StatisticsID, stats.name AS StatisticsName'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', partitions.partition_id AS PartitionID, partitions.partition_number AS PartitionNumber, IndexPartitions.partition_count AS PartitionCount'
          IF @PartitionLevel = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ', NULL AS PartitionID, NULL AS PartitionNumber, NULL AS PartitionCount'
          SET @CurrentCommand01 = @CurrentCommand01 + ', 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables ON objects.[object_id] = tables.[object_id] LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats ON indexes.[object_id] = stats.[object_id] AND indexes.[index_id] = stats.[stats_id]'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id LEFT OUTER JOIN (SELECT partitions.[object_id], partitions.index_id, COUNT(*) AS partition_count FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions GROUP BY partitions.[object_id], partitions.index_id) IndexPartitions ON partitions.[object_id] = IndexPartitions.[object_id] AND partitions.[index_id] = IndexPartitions.[index_id]'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.dm_db_partition_stats dm_db_partition_stats ON indexes.[object_id] = dm_db_partition_stats.[object_id] AND indexes.[index_id] = dm_db_partition_stats.[index_id] AND partitions.partition_id = dm_db_partition_stats.partition_id'
          IF @PartitionLevel = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN (SELECT dm_db_partition_stats.[object_id], dm_db_partition_stats.[index_id], SUM(dm_db_partition_stats.in_row_data_page_count) AS in_row_data_page_count FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.dm_db_partition_stats dm_db_partition_stats GROUP BY dm_db_partition_stats.[object_id], dm_db_partition_stats.[index_id]) dm_db_partition_stats ON indexes.[object_id] = dm_db_partition_stats.[object_id] AND indexes.[index_id] = dm_db_partition_stats.[index_id]'
          SET @CurrentCommand01 = @CurrentCommand01 + ' WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0'
          IF (@UpdateStatistics NOT IN('ALL','INDEX') OR @UpdateStatistics IS NULL) AND @PageCountLevel > 0 SET @CurrentCommand01 = @CurrentCommand01 + ' AND (dm_db_partition_stats.in_row_data_page_count >= @ParamPageCountLevel OR dm_db_partition_stats.in_row_data_page_count IS NULL)'
          IF NOT EXISTS(SELECT * FROM @ActionsPreferred) SET @CurrentCommand01 = @CurrentCommand01 + ' AND stats.stats_id IS NOT NULL'
        END

        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL' SET @CurrentCommand01 = @CurrentCommand01 + ' UNION '

        IF @UpdateStatistics IN('ALL','COLUMNS') SET @CurrentCommand01 = @CurrentCommand01 + 'SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE 'NULL' END + ' AS IsMemoryOptimized, NULL AS IndexID, NULL AS IndexName, NULL AS IndexType, stats.stats_id AS StatisticsID, stats.name AS StatisticsName, NULL AS PartitionID, NULL AS PartitionNumber, NULL AS PartitionCount, 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables ON objects.[object_id] = tables.[object_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND NOT EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.[object_id] = stats.[object_id] AND indexes.index_id = stats.stats_id)'

        SET @CurrentCommand01 = @CurrentCommand01 + ') IndexesStatistics ORDER BY SchemaName ASC, ObjectName ASC'
        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL' SET @CurrentCommand01 = @CurrentCommand01 + ', CASE WHEN IndexType IS NULL THEN 1 ELSE 0 END ASC'
        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX') SET @CurrentCommand01 = @CurrentCommand01 + ', IndexType ASC, IndexName ASC'
        IF @UpdateStatistics IN('ALL','COLUMNS') SET @CurrentCommand01 = @CurrentCommand01 + ', StatisticsName ASC'
        IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', PartitionNumber ASC'

        INSERT INTO @tmpIndexesStatistics (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, StatisticsID, StatisticsName, PartitionID, PartitionNumber, PartitionCount, Selected, Completed)
        EXECUTE sp_executesql @statement = @CurrentCommand01, @params = N'@ParamPageCountLevel int', @ParamPageCountLevel = @PageCountLevel
        SET @Error = @@ERROR
        IF @Error <> 0
        BEGIN
          SET @ReturnCode = @Error
        END
      END

      IF @Indexes IS NULL
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = 1
        FROM @tmpIndexesStatistics tmpIndexesStatistics
      END
      ELSE
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 1

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 0
      END

      WHILE EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE Selected = 1 AND Completed = 0 AND (GETDATE() < DATEADD(ss,@TimeLimit,@StartTime) OR @TimeLimit IS NULL))
      BEGIN

        SELECT TOP 1 @CurrentIxID = ID,
                     @CurrentSchemaID = SchemaID,
                     @CurrentSchemaName = SchemaName,
                     @CurrentObjectID = ObjectID,
                     @CurrentObjectName = ObjectName,
                     @CurrentObjectType = ObjectType,
                     @CurrentIsMemoryOptimized = IsMemoryOptimized,
                     @CurrentIndexID = IndexID,
                     @CurrentIndexName = IndexName,
                     @CurrentIndexType = IndexType,
                     @CurrentStatisticsID = StatisticsID,
                     @CurrentStatisticsName = StatisticsName,
                     @CurrentPartitionID = PartitionID,
                     @CurrentPartitionNumber = PartitionNumber,
                     @CurrentPartitionCount = PartitionCount
        FROM @tmpIndexesStatistics
        WHERE Selected = 1
        AND Completed = 0
        ORDER BY ID ASC

        -- Is the index a partition?
        IF @CurrentPartitionNumber IS NULL OR @CurrentPartitionCount = 1 BEGIN SET @CurrentIsPartition = 0 END ELSE BEGIN SET @CurrentIsPartition = 1 END

        -- Does the index exist?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand02 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand02 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          IF @CurrentIsPartition = 0 SET @CurrentCommand02 = @CurrentCommand02 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType) BEGIN SET @ParamIndexExists = 1 END'
          IF @CurrentIsPartition = 1 SET @CurrentCommand02 = @CurrentCommand02 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType AND partitions.partition_id = @ParamPartitionID AND partitions.partition_number = @ParamPartitionNumber) BEGIN SET @ParamIndexExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand02, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamIndexID int, @ParamIndexName sysname, @ParamIndexType int, @ParamPartitionID bigint, @ParamPartitionNumber int, @ParamIndexExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamIndexID = @CurrentIndexID, @ParamIndexName = @CurrentIndexName, @ParamIndexType = @CurrentIndexType, @ParamPartitionID = @CurrentPartitionID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamIndexExists = @CurrentIndexExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIndexExists IS NULL SET @CurrentIndexExists = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index exists.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
          IF @CurrentIndexExists = 0 GOTO NoAction
        END

        -- Does the statistics exist?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand03 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand03 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand03 = @CurrentCommand03 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND stats.stats_id = @ParamStatisticsID AND stats.[name] = @ParamStatisticsName) BEGIN SET @ParamStatisticsExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand03, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamStatisticsID int, @ParamStatisticsName sysname, @ParamStatisticsExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsName = @CurrentStatisticsName, @ParamStatisticsExists = @CurrentStatisticsExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentStatisticsExists IS NULL SET @CurrentStatisticsExists = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the statistics exists.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
          IF @CurrentStatisticsExists = 0 GOTO NoAction
        END

        -- Is one of the columns in the index an image, text or ntext data type?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType = 1 AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand04 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand04 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand04 = @CurrentCommand04 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id WHERE columns.[object_id] = @ParamObjectID AND types.name IN(''image'',''text'',''ntext'')) BEGIN SET @ParamIsImageText = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand04, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsImageText bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsImageText = @CurrentIsImageText OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsImageText IS NULL SET @CurrentIsImageText = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index contains any image, text, or ntext data types.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is one of the columns in the index an xml, varchar(max), nvarchar(max), varbinary(max) or large CLR data type?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN(1,2) AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand05 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand05 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          IF @CurrentIndexType = 1 SET @CurrentCommand05 = @CurrentCommand05 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE columns.[object_id] = @ParamObjectID AND (types.name IN(''xml'') OR (types.name IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) BEGIN SET @ParamIsNewLOB = 1 END'
          IF @CurrentIndexType = 2 SET @CurrentCommand05 = @CurrentCommand05 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.index_columns index_columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE index_columns.[object_id] = @ParamObjectID AND index_columns.index_id = @ParamIndexID AND (types.[name] IN(''xml'') OR (types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) BEGIN SET @ParamIsNewLOB = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand05, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsNewLOB bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsNewLOB = @CurrentIsNewLOB OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsNewLOB IS NULL SET @CurrentIsNewLOB = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index contains any xml, varchar(max), nvarchar(max), varbinary(max), or large CLR data types.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is one of the columns in the index a file stream column?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType = 1 AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand06 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand06 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand06 = @CurrentCommand06 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns WHERE columns.[object_id] = @ParamObjectID  AND columns.is_filestream = 1) BEGIN SET @ParamIsFileStream = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand06, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsFileStream bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsFileStream = @CurrentIsFileStream OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsFileStream IS NULL SET @CurrentIsFileStream = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index contains any file stream columns.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is there a columnstore index on the table?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred) AND @Version >= 11
        BEGIN
          SET @CurrentCommand07 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand07 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand07 = @CurrentCommand07 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.[object_id] = @ParamObjectID AND [type] IN(5,6)) BEGIN SET @ParamIsColumnStore = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand07, @params = N'@ParamObjectID int, @ParamIsColumnStore bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIsColumnStore = @CurrentIsColumnStore OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsColumnStore IS NULL SET @CurrentIsColumnStore = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if there is a columnstore index on the table.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is Allow_Page_Locks set to On?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand08 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand08 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand08 = @CurrentCommand08 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID AND indexes.[allow_page_locks] = 1) BEGIN SET @ParamAllowPageLocks = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand08, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamAllowPageLocks bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamAllowPageLocks = @CurrentAllowPageLocks OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentAllowPageLocks IS NULL SET @CurrentAllowPageLocks = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if page locking is enabled on the index.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is No_Recompute set to On?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand09 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand09 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand09 = @CurrentCommand09 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats WHERE stats.[object_id] = @ParamObjectID AND stats.[stats_id] = @ParamStatisticsID AND stats.[no_recompute] = 1) BEGIN SET @ParamNoRecompute = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand09, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamNoRecompute bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamNoRecompute = @CurrentNoRecompute OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentNoRecompute IS NULL SET @CurrentNoRecompute = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if automatic statistics update is enabled.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Has the data in the statistics been modified since the statistics was last updated?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL AND @OnlyModifiedStatistics = 'Y'
        BEGIN
          SET @CurrentCommand10 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand10 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          IF (@Version >= 10.504000 AND @Version < 11) OR @Version >= 11.03000
          BEGIN
            SET @CurrentCommand10 = @CurrentCommand10 + 'USE ' + QUOTENAME(@CurrentDatabaseName) + '; IF EXISTS(SELECT * FROM sys.dm_db_stats_properties (@ParamObjectID, @ParamStatisticsID) WHERE modification_counter > 0) BEGIN SET @ParamStatisticsModified = 1 END'
          END
          ELSE
          BEGIN
            SET @CurrentCommand10 = @CurrentCommand10 + 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.sysindexes sysindexes WHERE sysindexes.[id] = @ParamObjectID AND sysindexes.[indid] = @ParamStatisticsID AND sysindexes.[rowmodctr] <> 0) BEGIN SET @ParamStatisticsModified = 1 END'
          END

          EXECUTE sp_executesql @statement = @CurrentCommand10, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamStatisticsModified bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsModified = @CurrentStatisticsModified OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentStatisticsModified IS NULL SET @CurrentStatisticsModified = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if any rows has been modified since the most recent statistics update.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is the index on a read-only filegroup?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand11 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand11 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand11 = @CurrentCommand11 + 'IF EXISTS(SELECT * FROM (SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.destination_data_spaces destination_data_spaces ON indexes.data_space_id = destination_data_spaces.partition_scheme_id INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON destination_data_spaces.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID'
          IF @CurrentIsPartition = 1 SET @CurrentCommand11 = @CurrentCommand11 + ' AND destination_data_spaces.destination_id = @ParamPartitionNumber'
          SET @CurrentCommand11 = @CurrentCommand11 + ' UNION SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON indexes.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID'
          IF @CurrentIndexType = 1 SET @CurrentCommand11 = @CurrentCommand11 + ' UNION SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON tables.lob_data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND tables.[object_id] = @ParamObjectID'
          SET @CurrentCommand11 = @CurrentCommand11 + ') ReadOnlyFileGroups) BEGIN SET @ParamOnReadOnlyFileGroup = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand11, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamOnReadOnlyFileGroup bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamOnReadOnlyFileGroup = @CurrentOnReadOnlyFileGroup OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentOnReadOnlyFileGroup IS NULL SET @CurrentOnReadOnlyFileGroup = 0
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index is on a read-only filegroup.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is the index fragmented?
        IF @CurrentIndexID IS NOT NULL
        AND @CurrentOnReadOnlyFileGroup = 0
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3) OR @PageCountLevel > 0)
        BEGIN
          SET @CurrentCommand12 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand12 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand12 = @CurrentCommand12 + 'SELECT @ParamFragmentationLevel = MAX(avg_fragmentation_in_percent), @ParamPageCount = SUM(page_count) FROM sys.dm_db_index_physical_stats(@ParamDatabaseID, @ParamObjectID, @ParamIndexID, @ParamPartitionNumber, ''LIMITED'') WHERE alloc_unit_type_desc = ''IN_ROW_DATA'' AND index_level = 0'

          EXECUTE sp_executesql @statement = @CurrentCommand12, @params = N'@ParamDatabaseID int, @ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamFragmentationLevel float OUTPUT, @ParamPageCount bigint OUTPUT', @ParamDatabaseID = @CurrentDatabaseID, @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamFragmentationLevel = @CurrentFragmentationLevel OUTPUT, @ParamPageCount = @CurrentPageCount OUTPUT
          SET @Error = @@ERROR
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The size and fragmentation of the index could not be checked.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
          END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Select fragmentation group
        IF @CurrentIndexID IS NOT NULL AND @CurrentOnReadOnlyFileGroup = 0 AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentFragmentationGroup = CASE
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel2 THEN 'High'
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 THEN 'Medium'
          WHEN @CurrentFragmentationLevel < @FragmentationLevel1 THEN 'Low'
          END
        END

        -- Which actions are allowed?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL) AND (@CurrentAllowPageLocks = 1 OR @CurrentIndexType = 5)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REORGANIZE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_OFFLINE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0
          AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          AND (@CurrentIsPartition = 0 OR @Version >= 12)
          AND ((@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 2 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsFileStream = 0 AND @Version >= 11)
          OR (@CurrentIndexType = 2 AND @Version >= 11))
          AND (@CurrentIsColumnStore = 0 OR @Version < 11)
          AND SERVERPROPERTY('EngineEdition') IN (3,5)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_ONLINE')
          END
        END

        -- Decide action
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (@CurrentPageCount >= @PageCountLevel OR @PageCountLevel = 0)
        BEGIN
          IF EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3)
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE FragmentationGroup = @CurrentFragmentationGroup
            AND [Priority] = (SELECT MIN([Priority])
                              FROM @ActionsPreferred
                              WHERE FragmentationGroup = @CurrentFragmentationGroup
                              AND [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
          ELSE
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE [Priority] = (SELECT MIN([Priority])
                                FROM @ActionsPreferred
                                WHERE [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
        END

        -- Workaround for limitation in SQL Server, http://support.microsoft.com/kb/2292737
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentMaxDOP = @MaxDOP
          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentAllowPageLocks = 0
          BEGIN
            SET @CurrentMaxDOP = 1
          END
        END

        -- Update statistics?
        IF @CurrentStatisticsID IS NOT NULL
        AND ((@UpdateStatistics = 'ALL' AND (@CurrentIndexType IN (1,2,3,4,7) OR @CurrentIndexID IS NULL)) OR (@UpdateStatistics = 'INDEX' AND @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN (1,2,3,4,7)) OR (@UpdateStatistics = 'COLUMNS' AND @CurrentIndexID IS NULL))
        AND (@CurrentStatisticsModified = 1 OR @OnlyModifiedStatistics = 'N' OR @CurrentIsMemoryOptimized = 1)
        AND ((@CurrentIsPartition = 0 AND (@CurrentAction NOT IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') OR @CurrentAction IS NULL)) OR (@CurrentIsPartition = 1 AND @CurrentPartitionNumber = @CurrentPartitionCount))
        BEGIN
          SET @CurrentUpdateStatistics = 'Y'
        END
        ELSE
        BEGIN
          SET @CurrentUpdateStatistics = 'N'
        END

        SET @CurrentStatisticsSample = @StatisticsSample
        SET @CurrentStatisticsResample = @StatisticsResample

        -- Memory-optimized tables only supports FULLSCAN and RESAMPLE in SQL Server 2014
        IF @CurrentIsMemoryOptimized = 1 AND @Version >= 12 AND @Version < 13 AND (@CurrentStatisticsSample <> 100 OR @CurrentStatisticsSample IS NULL)
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Create comment
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'ImageText: ' + CASE WHEN @CurrentIsImageText = 1 THEN 'Yes' WHEN @CurrentIsImageText = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'NewLOB: ' + CASE WHEN @CurrentIsNewLOB = 1 THEN 'Yes' WHEN @CurrentIsNewLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'FileStream: ' + CASE WHEN @CurrentIsFileStream = 1 THEN 'Yes' WHEN @CurrentIsFileStream = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 11 SET @CurrentComment = @CurrentComment + 'ColumnStore: ' + CASE WHEN @CurrentIsColumnStore = 1 THEN 'Yes' WHEN @CurrentIsColumnStore = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'AllowPageLocks: ' + CASE WHEN @CurrentAllowPageLocks = 1 THEN 'Yes' WHEN @CurrentAllowPageLocks = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'PageCount: ' + ISNULL(CAST(@CurrentPageCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment = @CurrentComment + 'Fragmentation: ' + ISNULL(CAST(@CurrentFragmentationLevel AS nvarchar),'N/A')
        END

        IF @CurrentIndexID IS NOT NULL AND (@CurrentPageCount IS NOT NULL OR @CurrentFragmentationLevel IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentPageCount AS nvarchar) AS [PageCount],
                                                 CAST(@CurrentFragmentationLevel AS nvarchar) AS Fragmentation
                                    ) ExtendedInfo FOR XML AUTO, ELEMENTS)
        END

        IF @CurrentIndexID IS NOT NULL AND @CurrentAction IS NOT NULL AND (GETDATE() < DATEADD(ss,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentCommandType13 = 'ALTER_INDEX'

          SET @CurrentCommand13 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand13 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand13 = @CurrentCommand13 + 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName)

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE')
          BEGIN
            SET @CurrentCommand13 = @CurrentCommand13 + ' REBUILD'
            IF @CurrentIsPartition = 1 SET @CurrentCommand13 = @CurrentCommand13 + ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)
            SET @CurrentCommand13 = @CurrentCommand13 + ' WITH ('
            IF @SortInTempdb = 'Y' AND @CurrentIndexType IN(1,2,3,4) SET @CurrentCommand13 = @CurrentCommand13 + 'SORT_IN_TEMPDB = ON'
            IF @SortInTempdb = 'N' AND @CurrentIndexType IN(1,2,3,4) SET @CurrentCommand13 = @CurrentCommand13 + 'SORT_IN_TEMPDB = OFF'
            IF @CurrentIndexType IN(1,2,3,4) AND (@CurrentIsPartition = 0 OR @Version >= 12) SET @CurrentCommand13 = @CurrentCommand13 + ', '
            IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) SET @CurrentCommand13 = @CurrentCommand13 + 'ONLINE = ON'
            IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @WaitAtLowPriorityMaxDuration IS NOT NULL SET @CurrentCommand13 = @CurrentCommand13 + ' (WAIT_AT_LOW_PRIORITY (MAX_DURATION = ' + CAST(@WaitAtLowPriorityMaxDuration AS nvarchar) + ', ABORT_AFTER_WAIT = ' + UPPER(@WaitAtLowPriorityAbortAfterWait) + '))'
            IF @CurrentAction = 'INDEX_REBUILD_OFFLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) SET @CurrentCommand13 = @CurrentCommand13 + 'ONLINE = OFF'
            IF @CurrentMaxDOP IS NOT NULL SET @CurrentCommand13 = @CurrentCommand13 + ', MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
            IF @FillFactor IS NOT NULL AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) SET @CurrentCommand13 = @CurrentCommand13 + ', FILLFACTOR = ' + CAST(@FillFactor AS nvarchar)
            IF @PadIndex = 'Y' AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) SET @CurrentCommand13 = @CurrentCommand13 + ', PAD_INDEX = ON'
            IF @PadIndex = 'N' AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) SET @CurrentCommand13 = @CurrentCommand13 + ', PAD_INDEX = OFF'
            SET @CurrentCommand13 = @CurrentCommand13 + ')'
          END

          IF @CurrentAction IN('INDEX_REORGANIZE')
          BEGIN
            SET @CurrentCommand13 = @CurrentCommand13 + ' REORGANIZE'
            IF @CurrentIsPartition = 1 SET @CurrentCommand13 = @CurrentCommand13 + ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)
            SET @CurrentCommand13 = @CurrentCommand13 + ' WITH ('
            IF @LOBCompaction = 'Y' SET @CurrentCommand13 = @CurrentCommand13 + 'LOB_COMPACTION = ON'
            IF @LOBCompaction = 'N' SET @CurrentCommand13 = @CurrentCommand13 + 'LOB_COMPACTION = OFF'
            SET @CurrentCommand13 = @CurrentCommand13 + ')'
          END

          EXECUTE @CurrentCommandOutput13 = [dbo].[CommandExecute] @Command = @CurrentCommand13, @CommandType = @CurrentCommandType13, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @PartitionNumber = @CurrentPartitionNumber, @ExtendedInfo = @CurrentExtendedInfo, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput13 = @Error
          IF @CurrentCommandOutput13 <> 0 SET @ReturnCode = @CurrentCommandOutput13

          IF @Delay > 0
          BEGIN
            SET @CurrentDelay = DATEADD(ss,@Delay,'1900-01-01')
            WAITFOR DELAY @CurrentDelay
          END
        END

        IF @CurrentStatisticsID IS NOT NULL AND @CurrentUpdateStatistics = 'Y' AND (GETDATE() < DATEADD(ss,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentCommandType14 = 'UPDATE_STATISTICS'

          SET @CurrentCommand14 = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand14 = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand14 = @CurrentCommand14 + 'UPDATE STATISTICS ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentStatisticsName)
          IF @CurrentStatisticsSample IS NOT NULL OR @CurrentStatisticsResample = 'Y' OR @CurrentNoRecompute = 1 SET @CurrentCommand14 = @CurrentCommand14 + ' WITH'
          IF @CurrentStatisticsSample = 100 SET @CurrentCommand14 = @CurrentCommand14 + ' FULLSCAN'
          IF @CurrentStatisticsSample IS NOT NULL AND @CurrentStatisticsSample <> 100 SET @CurrentCommand14 = @CurrentCommand14 + ' SAMPLE ' + CAST(@CurrentStatisticsSample AS nvarchar) + ' PERCENT'
          IF @CurrentStatisticsResample = 'Y' SET @CurrentCommand14 = @CurrentCommand14 + ' RESAMPLE'
          IF (@CurrentStatisticsSample IS NOT NULL OR @CurrentStatisticsResample = 'Y') AND @CurrentNoRecompute = 1 SET @CurrentCommand14 = @CurrentCommand14 + ','
          IF @CurrentNoRecompute = 1 SET @CurrentCommand14 = @CurrentCommand14 + ' NORECOMPUTE'

          EXECUTE @CurrentCommandOutput14 = [dbo].[CommandExecute] @Command = @CurrentCommand14, @CommandType = @CurrentCommandType14, @Mode = 2, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @StatisticsName = @CurrentStatisticsName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput14 = @Error
          IF @CurrentCommandOutput14 <> 0 SET @ReturnCode = @CurrentCommandOutput14
        END

        NoAction:

        -- Update that the index is completed
        UPDATE @tmpIndexesStatistics
        SET Completed = 1
        WHERE Selected = 1
        AND Completed = 0
        AND ID = @CurrentIxID

        -- Clear variables
        SET @CurrentCommand02 = NULL
        SET @CurrentCommand03 = NULL
        SET @CurrentCommand04 = NULL
        SET @CurrentCommand05 = NULL
        SET @CurrentCommand06 = NULL
        SET @CurrentCommand07 = NULL
        SET @CurrentCommand08 = NULL
        SET @CurrentCommand09 = NULL
        SET @CurrentCommand10 = NULL
        SET @CurrentCommand11 = NULL
        SET @CurrentCommand12 = NULL
        SET @CurrentCommand13 = NULL
        SET @CurrentCommand14 = NULL

        SET @CurrentCommandOutput13 = NULL
        SET @CurrentCommandOutput14 = NULL

        SET @CurrentCommandType13 = NULL
        SET @CurrentCommandType14 = NULL

        SET @CurrentIxID = NULL
        SET @CurrentSchemaID = NULL
        SET @CurrentSchemaName = NULL
        SET @CurrentObjectID = NULL
        SET @CurrentObjectName = NULL
        SET @CurrentObjectType = NULL
        SET @CurrentIsMemoryOptimized = NULL
        SET @CurrentIndexID = NULL
        SET @CurrentIndexName = NULL
        SET @CurrentIndexType = NULL
        SET @CurrentStatisticsID = NULL
        SET @CurrentStatisticsName = NULL
        SET @CurrentPartitionID = NULL
        SET @CurrentPartitionNumber = NULL
        SET @CurrentPartitionCount = NULL
        SET @CurrentIsPartition = NULL
        SET @CurrentIndexExists = NULL
        SET @CurrentStatisticsExists = NULL
        SET @CurrentIsImageText = NULL
        SET @CurrentIsNewLOB = NULL
        SET @CurrentIsFileStream = NULL
        SET @CurrentIsColumnStore = NULL
        SET @CurrentAllowPageLocks = NULL
        SET @CurrentNoRecompute = NULL
        SET @CurrentStatisticsModified = NULL
        SET @CurrentOnReadOnlyFileGroup = NULL
        SET @CurrentFragmentationLevel = NULL
        SET @CurrentPageCount = NULL
        SET @CurrentFragmentationGroup = NULL
        SET @CurrentAction = NULL
        SET @CurrentMaxDOP = NULL
        SET @CurrentUpdateStatistics = NULL
        SET @CurrentStatisticsSample = NULL
        SET @CurrentStatisticsResample = NULL
        SET @CurrentComment = NULL
        SET @CurrentExtendedInfo = NULL

        DELETE FROM @CurrentActionsAllowed

      END

    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE Selected = 1
    AND Completed = 0
    AND ID = @CurrentDBID

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentDatabaseMirroringRole = NULL
    SET @CurrentIsReadOnly = NULL

    SET @CurrentCommand01 = NULL

    DELETE FROM @tmpIndexesStatistics

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END


GO
/****** Object:  StoredProcedure [dbo].[spr_ExecDatabaseBackupDiff]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupDiff]
AS
BEGIN
DECLARE @cmd NVARCHAR(MAX) = 'EXEC [AdminDB].[dbo].[DatabaseBackup] '

-- LOOP THROUGH ALL PARAMETERS CONFIG
DECLARE curConfig CURSOR
	FOR SELECT [Parameter], [Value], [ValueDataType] FROM [CONFIG].[tblDatabaseBackupDiff]

DECLARE @parameter NVARCHAR(MAX)
DECLARE @value NVARCHAR(MAX)
DECLARE @valueDataType NVARCHAR(MAX)
DECLARE @loopCount INT = 0
OPEN curConfig

FETCH NEXT FROM curConfig
INTO @parameter, @value, @valueDataType

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Comma separate parameters
	IF @loopCount > 0
	BEGIN
		SET @cmd += ', '
	END

	SET @cmd += @parameter + ' = '

	-- CHECK IF VALUE = [NULL]
	IF @value = '[NULL]'
	BEGIN
		SET @cmd+= 'NULL'
	END
	ELSE
	BEGIN

		-- CHECK DATA TYPE
		IF @valueDataType LIKE '%CHAR%'
		BEGIN
			SET  @cmd+= '''' + @value + ''''
		END
		ELSE -- IF DATA TYPE IS OTHER THAN NVARCHAR - eg INT
		BEGIN
			SET @cmd += '' + CONVERT(NVARCHAR(MAX), @value) + ''
		END
	END

	FETCH NEXT FROM curConfig
	INTO @parameter, @value, @valueDataType
	SET @loopCount+=1
END

CLOSE curConfig
DEALLOCATE curConfig

-- EXECUTE
EXEC [master]..[sp_executesql] @cmd
END
GO
/****** Object:  StoredProcedure [dbo].[spr_ExecDatabaseBackupFull]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupFull]
AS
BEGIN
DECLARE @cmd NVARCHAR(MAX) = 'EXEC [AdminDB].[dbo].[DatabaseBackup] '

-- LOOP THROUGH ALL PARAMETERS CONFIG
DECLARE curConfig CURSOR
	FOR SELECT [Parameter], [Value], [ValueDataType] FROM [CONFIG].[tblDatabaseBackupFull]

DECLARE @parameter NVARCHAR(MAX)
DECLARE @value NVARCHAR(MAX)
DECLARE @valueDataType NVARCHAR(MAX)
DECLARE @loopCount INT = 0
OPEN curConfig

FETCH NEXT FROM curConfig
INTO @parameter, @value, @valueDataType

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Comma separate parameters
	IF @loopCount > 0
	BEGIN
		SET @cmd += ', '
	END

	SET @cmd += @parameter + ' = '

	-- CHECK IF VALUE = [NULL]
	IF @value = '[NULL]'
	BEGIN
		SET @cmd+= 'NULL'
	END
	ELSE
	BEGIN

		-- CHECK DATA TYPE
		IF @valueDataType LIKE '%CHAR%'
		BEGIN
			SET  @cmd+= '''' + @value + ''''
		END
		ELSE -- IF DATA TYPE IS OTHER THAN NVARCHAR - eg INT
		BEGIN
			SET @cmd += '' + CONVERT(NVARCHAR(MAX), @value) + ''
		END
	END

	FETCH NEXT FROM curConfig
	INTO @parameter, @value, @valueDataType
	SET @loopCount+=1
END

CLOSE curConfig
DEALLOCATE curConfig

-- EXECUTE
EXEC [master]..[sp_executesql] @cmd
END
GO
/****** Object:  StoredProcedure [dbo].[spr_ExecDatabaseBackupLog]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupLog]
AS
BEGIN
DECLARE @cmd NVARCHAR(MAX) = 'EXEC [AdminDB].[dbo].[DatabaseBackup] '

-- LOOP THROUGH ALL PARAMETERS CONFIG
DECLARE curConfig CURSOR
	FOR SELECT [Parameter], [Value], [ValueDataType] FROM [CONFIG].[tblDatabaseBackupLog]

DECLARE @parameter NVARCHAR(MAX)
DECLARE @value NVARCHAR(MAX)
DECLARE @valueDataType NVARCHAR(MAX)
DECLARE @loopCount INT = 0
OPEN curConfig

FETCH NEXT FROM curConfig
INTO @parameter, @value, @valueDataType

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Comma separate parameters
	IF @loopCount > 0
	BEGIN
		SET @cmd += ', '
	END

	SET @cmd += @parameter + ' = '

	-- CHECK IF VALUE = [NULL]
	IF @value = '[NULL]'
	BEGIN
		SET @cmd+= 'NULL'
	END
	ELSE
	BEGIN

		-- CHECK DATA TYPE
		IF @valueDataType LIKE '%CHAR%'
		BEGIN
			SET  @cmd+= '''' + @value + ''''
		END
		ELSE -- IF DATA TYPE IS OTHER THAN NVARCHAR - eg INT
		BEGIN
			SET @cmd += '' + CONVERT(NVARCHAR(MAX), @value) + ''
		END
	END

	FETCH NEXT FROM curConfig
	INTO @parameter, @value, @valueDataType
	SET @loopCount+=1
END

CLOSE curConfig
DEALLOCATE curConfig

-- EXECUTE
EXEC [master]..[sp_executesql] @cmd
END
GO
/****** Object:  StoredProcedure [dbo].[spr_ExecDatabaseIntegrityCheck]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseIntegrityCheck]
AS
BEGIN
DECLARE @cmd NVARCHAR(MAX) = 'EXEC [AdminDB].[dbo].[DatabaseIntegrityCheck] '

-- LOOP THROUGH ALL PARAMETERS CONFIG
DECLARE curConfig CURSOR
	FOR SELECT [Parameter], [Value], [ValueDataType] FROM [CONFIG].[tblDatabaseIntegrityCheck]

DECLARE @parameter NVARCHAR(MAX)
DECLARE @value NVARCHAR(MAX)
DECLARE @valueDataType NVARCHAR(MAX)
DECLARE @loopCount INT = 0
OPEN curConfig

FETCH NEXT FROM curConfig
INTO @parameter, @value, @valueDataType

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Comma separate parameters
	IF @loopCount > 0
	BEGIN
		SET @cmd += ', '
	END

	SET @cmd += @parameter + ' = '

	-- CHECK IF VALUE = [NULL]
	IF @value = '[NULL]'
	BEGIN
		SET @cmd+= 'NULL'
	END
	ELSE
	BEGIN

		-- CHECK DATA TYPE
		IF @valueDataType LIKE '%CHAR%'
		BEGIN
			SET  @cmd+= '''' + @value + ''''
		END
		ELSE -- IF DATA TYPE IS OTHER THAN NVARCHAR - eg INT
		BEGIN
			SET @cmd += '' + CONVERT(NVARCHAR(MAX), @value) + ''
		END
	END

	FETCH NEXT FROM curConfig
	INTO @parameter, @value, @valueDataType
	SET @loopCount+=1
END

CLOSE curConfig
DEALLOCATE curConfig

-- EXECUTE
EXEC [master]..[sp_executesql] @cmd
END
GO
/****** Object:  StoredProcedure [dbo].[spr_ExecIndexOptimize]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecIndexOptimize]
AS
BEGIN
DECLARE @cmd NVARCHAR(MAX) = 'EXEC [AdminDB].[dbo].[IndexOptimize] '

-- LOOP THROUGH ALL PARAMETERS CONFIG
DECLARE curConfig CURSOR
	FOR SELECT [Parameter], [Value], [ValueDataType] FROM [CONFIG].[tblIndexOptimize]

DECLARE @parameter NVARCHAR(MAX)
DECLARE @value NVARCHAR(MAX)
DECLARE @valueDataType NVARCHAR(MAX)
DECLARE @loopCount INT = 0
OPEN curConfig

FETCH NEXT FROM curConfig
INTO @parameter, @value, @valueDataType

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Comma separate parameters
	IF @loopCount > 0
	BEGIN
		SET @cmd += ', '
	END

	SET @cmd += @parameter + ' = '

	-- CHECK IF VALUE = [NULL]
	IF @value = '[NULL]'
	BEGIN
		SET @cmd+= 'NULL'
	END
	ELSE
	BEGIN

		-- CHECK DATA TYPE
		IF @valueDataType LIKE '%CHAR%'
		BEGIN
			SET  @cmd+= '''' + @value + ''''
		END
		ELSE -- IF DATA TYPE IS OTHER THAN NVARCHAR - eg INT
		BEGIN
			SET @cmd += '' + CONVERT(NVARCHAR(MAX), @value) + ''
		END
	END

	FETCH NEXT FROM curConfig
	INTO @parameter, @value, @valueDataType
	SET @loopCount+=1
END

CLOSE curConfig
DEALLOCATE curConfig

-- EXECUTE
EXEC [master]..[sp_executesql] @cmd
--PRINT @cmd
END
GO
/****** Object:  StoredProcedure [dbo].[spr_HelpRevlogin]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spr_HelpRevlogin] @login_name sysname = NULL AS
DECLARE @name sysname
DECLARE @type varchar (1)
DECLARE @hasaccess int
DECLARE @denylogin int
DECLARE @is_disabled int
DECLARE @PWD_varbinary  varbinary (256)
DECLARE @PWD_string  varchar (514)
DECLARE @SID_varbinary varbinary (85)
DECLARE @SID_string varchar (514)
DECLARE @tmpstr  varchar (1024)
DECLARE @is_policy_checked varchar (3)
DECLARE @is_expiration_checked varchar (3)
DECLARE @is_sysadmin int
DECLARE @is_securityadmin int
DECLARE @is_serveradmin int
DECLARE @is_setupadmin int
DECLARE @is_processadmin int
DECLARE @is_diskadmin int
DECLARE @is_dbcreator int
DECLARE @is_bulkadmin int

DECLARE @defaultdb sysname
 
IF (@login_name IS NULL)
  DECLARE login_curs CURSOR FOR

      SELECT p.sid, 
			 p.name, 
			 p.type, 
			 p.is_disabled, 
			 p.default_database_name, 
			 l.hasaccess, 
			 l.denylogin,
			 l.sysadmin,
			 l.securityadmin,
			 l.serveradmin,
			 l.setupadmin,
			 l.processadmin,
			 l.diskadmin,
			 l.dbcreator,
			 l.bulkadmin 
	  FROM 
sys.server_principals p LEFT JOIN sys.syslogins l
      ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name <> 'sa'
ELSE
  DECLARE login_curs CURSOR FOR


      SELECT p.sid, 
			 p.name, 
			 p.type, 
			 p.is_disabled, 
			 p.default_database_name, 
			 l.hasaccess, 
			 l.denylogin,
			 l.sysadmin,
			 l.securityadmin,
			 l.serveradmin,
			 l.setupadmin,
			 l.processadmin,
			 l.diskadmin,
			 l.dbcreator,
			 l.bulkadmin  
	 FROM 
sys.server_principals p LEFT JOIN sys.syslogins l
      ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name = @login_name
OPEN login_curs

FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @is_sysadmin, @is_securityadmin, @is_serveradmin, @is_setupadmin, @is_processadmin, @is_diskadmin, @is_dbcreator, @is_bulkadmin
IF (@@fetch_status = -1)
BEGIN
  CLOSE login_curs
  DEALLOCATE login_curs
  RETURN -1
END
SET @tmpstr = '/* sp_help_revlogin script '
SET @tmpstr = '** Generated ' + CONVERT (varchar, GETDATE()) + ' on ' + @@SERVERNAME + ' */'
WHILE (@@fetch_status <> -1)
BEGIN
  IF (@@fetch_status <> -2)
  BEGIN
    SET @tmpstr = '-- Login: ' + @name
    IF (@type IN ( 'G', 'U'))
    BEGIN -- NT authenticated account/group
      SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_DATABASE = [' + @defaultdb + ']'
    END
    ELSE BEGIN -- SQL Server authentication
        -- obtain password and sid
            SET @PWD_varbinary = CAST( LOGINPROPERTY( @name, 'PasswordHash' ) AS varbinary (256) )
        EXEC spr_Hexadecimal @PWD_varbinary, @PWD_string OUT
        EXEC spr_Hexadecimal @SID_varbinary,@SID_string OUT
 
        -- obtain password policy state
        SELECT @is_policy_checked = CASE is_policy_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
        SELECT @is_expiration_checked = CASE is_expiration_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
 
            SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' + @SID_string + ', DEFAULT_DATABASE = [' + @defaultdb + ']'

        IF ( @is_policy_checked IS NOT NULL )
        BEGIN
          SET @tmpstr = @tmpstr + ', CHECK_POLICY = ' + @is_policy_checked
        END
        IF ( @is_expiration_checked IS NOT NULL )
        BEGIN
          SET @tmpstr = @tmpstr + ', CHECK_EXPIRATION = ' + @is_expiration_checked
        END
    END
    IF (@denylogin = 1)
    BEGIN -- login is denied access
      SET @tmpstr = @tmpstr + '; DENY CONNECT SQL TO ' + QUOTENAME( @name )
    END
    ELSE IF (@hasaccess = 0)
    BEGIN -- login exists but does not have access
      SET @tmpstr = @tmpstr + '; REVOKE CONNECT SQL TO ' + QUOTENAME( @name )
    END
    IF (@is_disabled = 1)
    BEGIN -- login is disabled
      SET @tmpstr = @tmpstr + '; ALTER LOGIN ' + QUOTENAME( @name ) + ' DISABLE'
    END

	------------------------------------------------------------------
	-- CHECK ROLES
	------------------------------------------------------------------
	--SysAdmin
	IF (@is_sysadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [sysadmin] ADD MEMBER [' + @name +']'
	END

	--SecurityAdmin
	IF (@is_securityadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [securityadmin] ADD MEMBER [' + @name +']'
	END

	--ServerAdmin
	IF (@is_serveradmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [serveradmin] ADD MEMBER [' + @name +']'
	END

	--SetupAdmin
	IF (@is_setupadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [setupadmin] ADD MEMBER [' + @name +']'
	END

	--ProcessAdmin
	IF (@is_processadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [processadmin] ADD MEMBER [' + @name +']'
	END

	--DiskAdmin
	IF (@is_diskadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [diskadmin] ADD MEMBER [' + @name +']'
	END

	--DBCreator
	IF (@is_dbcreator = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [dbcreator] ADD MEMBER [' + @name +']'
	END

	--BulkAdmin
	IF (@is_bulkadmin = 1)
	BEGIN
		SET @tmpstr = @tmpstr + '; ALTER SERVER ROLE [bulkadmin] ADD MEMBER [' + @name +']'
	END

	-- INSERT INTO TABLE
    IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AdminDB') 
	  INSERT INTO AdminDB.dbo.BackupLogins (RunDate, CreateLoginStatement)
	    VALUES (getdate(), @tmpstr)
	END

  FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @is_sysadmin, @is_securityadmin, @is_serveradmin, @is_setupadmin, @is_processadmin, @is_diskadmin, @is_dbcreator, @is_bulkadmin
   END
CLOSE login_curs
DEALLOCATE login_curs
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[spr_Hexadecimal]    Script Date: 16.01.2018 20:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spr_Hexadecimal]
    @binvalue varbinary(256),
    @hexvalue varchar (514) OUTPUT
AS
DECLARE @charvalue varchar (514)
DECLARE @i int
DECLARE @length int
DECLARE @hexstring char(16)
SELECT @charvalue = '0x'
SELECT @i = 1
SELECT @length = DATALENGTH (@binvalue)
SELECT @hexstring = '0123456789ABCDEF'
WHILE (@i <= @length)
BEGIN
  DECLARE @tempint int
  DECLARE @firstint int
  DECLARE @secondint int
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +
    SUBSTRING(@hexstring, @firstint+1, 1) +
    SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END

SELECT @hexvalue = @charvalue
GO
USE [master]
GO
ALTER DATABASE [AdminDB] SET  READ_WRITE 
GO
--------------------------------------------------------------------------------------------------------
-- AGENT JOBS
--------------------------------------------------------------------------------------------------------
USE [msdb]
GO

/****** Object:  Job [01_MAINT_BACKUP_FULL]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'01_MAINT_BACKUP_FULL', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Full Backup]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Full Backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec spr_ExecDatabaseBackupFull', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180116, 
		@active_end_date=99991231, 
		@active_start_time=200000, 
		@active_end_time=235959, 
		@schedule_uid=N'13173113-0bb6-47c6-ae7f-17d59be059db'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [02_MAINT_BACKUP_DIFF]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'02_MAINT_BACKUP_DIFF', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Diff Backup]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Diff Backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC spr_ExecDatabaseBackupDiff', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180116, 
		@active_end_date=99991231, 
		@active_start_time=210000, 
		@active_end_time=235959, 
		@schedule_uid=N'2b0a9703-2ecc-454d-a719-dc01cb65be7b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [03_MAINT_BACKUP_LOG]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'03_MAINT_BACKUP_LOG', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Backup Log]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Backup Log', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC spr_ExecDatabaseBackupLog', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Hourly', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180116, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'9e5de5c9-9a3e-458c-acd6-c7d73bb69d28'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [04_MAINT_INDEX_STATS]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'04_MAINT_INDEX_STATS', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IndexOptimize]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IndexOptimize', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec spr_ExecIndexOptimize', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130625, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'78c0b4ae-4f4f-4b10-8848-e87b6b806b40'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [05_MAINT_CHECKDB]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'05_MAINT_CHECKDB', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CheckDB]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CheckDB', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec spr_ExecDatabaseIntegrityCheck', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Weekly', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20130625, 
		@active_end_date=99991231, 
		@active_start_time=130000, 
		@active_end_time=235959, 
		@schedule_uid=N'188ff5b6-1b78-4e96-ab2e-057d7689874a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [06_MAINT_BACKUP_LOGINS]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'06_MAINT_BACKUP_LOGINS', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BackupLogins]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BackupLogins', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC AdminDB.dbo.spr_HelpRevlogin', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SchedBackupLogins', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170501, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'fa250244-9c77-4c63-940e-83ee4811f86a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [07_MAINT_BACKUP_AGENTJOBS]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'07_MAINT_BACKUP_AGENTJOBS', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BackupJobs]    Script Date: 16.01.2018 20:56:44 ******/
DECLARE @myInstanceName NVARCHAR(MAX) = (SELECT CONVERT(NVARCHAR(MAX), SERVERPROPERTY('Servername')))
DECLARE @psJobStepCommand NVARCHAR(MAX) = '
#Backup AgentJobs to AdminDB Table
$MySQLInstance = "' + @myInstanceName +'" ##Enter Service Instance Name HERE!


#New Line
$nl = [System.Environment]::NewLine

$objConnection = New-Object System.Data.SqlClient.SqlConnection
$connectionString = "Server = $MySQLInstance; Integrated Security=SSPI;"
$objConnection.ConnectionString = $connectionString

#Create Command Object
$objCommand = New-Object System.Data.SqlClient.SqlCommand


#Open Connection
try
{
    $objConnection.Open()    
}
catch
{
    Exit 1
}

#Assign Connection to Command
$objCommand.Connection = $objConnection

#SMO Connector
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $MySQLInstance

#GetJobs
$myJobs = $srv.JobServer.Jobs

foreach ($job in $myJobs)
{
    $tmpName = $null
    $tmpScript = $null
    $tmpInsertStmt = $null
    $tmpName = $job.Name
    $tmpScript = "/***********" + $nl + "Replace [!%!] WITH single SQL apostroph!!!" + $nl + "*****************/" + $nl + $nl
    $tmpScript+= $job.Script() + $nl + "GO"
    $tmpScript = $tmpScript -replace "''", "[!%!]" 

    $tmpInsertStmt = "
        INSERT INTO [AdminDB].[dbo].[BackupJobs] (RunDate, JobName, CreateJobStatement)
        VALUES (
            GETDATE(),
            ''$tmpName'',
            ''$tmpScript''
        )
    "
    
    #Assign Command to objCommand
    $objCommand.CommandText = $tmpInsertStmt

    #Execute Command
    $objCommand.ExecuteScalar()

}

$objConnection.Close()
';
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BackupJobs', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=@psJobStepCommand, 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SchedJobsBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170511, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'52dff6a4-0c8e-4afe-b555-10e420411bfe'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [08_MAINT_CLEANUP_TASKS]    Script Date: 16.01.2018 20:56:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 16.01.2018 20:56:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'08_MAINT_CLEANUP_TASKS', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [AdminDB Command Log older 30 days]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'AdminDB Command Log older 30 days', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DELETE FROM [dbo].[CommandLog] 
WHERE StartTime < DATEADD(dd,-30,GETDATE())', 
		@database_name=N'AdminDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Backup History older 30 days]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Backup History older 30 days', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CleanupDate datetime 
SET @CleanupDate = DATEADD(dd,-30,GETDATE()) 
EXECUTE msdb.dbo.sp_delete_backuphistory @oldest_date = @CleanupDate', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Job History older 30 days]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Job History older 30 days', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CleanupDate datetime 
SET @CleanupDate = DATEADD(dd,-30,GETDATE()) 
EXECUTE msdb.dbo.sp_purge_jobhistory @oldest_date = @CleanupDate', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Recycle Error Log]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Recycle Error Log', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_cycle_errorlog', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Recycle Agent Log]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Recycle Agent Log', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_cycle_agent_errorlog', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Cleanup Mail Log]    Script Date: 16.01.2018 20:56:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Cleanup Mail Log', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sysmail_delete_log_sp', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180116, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'c0285aee-5aa1-4376-a05c-01e3106953a2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


