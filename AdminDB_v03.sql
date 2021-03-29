USE [master]
GO

-- RUN THIS SCIPT IN SQLCMD MODE!
--	Query --> SQLCMD Mode

-- Configurational variables
-- set database name
:setvar DATABASE_NAME "AdminDB"

-- Enable Jobs
:setvar EnableJobs 0

--##########################################################################################################################

--Static variables - please do NOT change
DECLARE @dbname NVARCHAR(MAX) = '$(DATABASE_NAME)'
DECLARE @cmd NVARCHAR(MAX) = ''
DECLARE @errorMsg NVARCHAR(4000) = ''
DECLARE @errCount INT = 0
DECLARE @tmpObjTable TABLE (ObjName NVARCHAR(MAX), checkValue INT)

-- START: Cleanup
-- Delete existing AdminDB Database and Jobs
-- Disable any TVDTools Jobs
SET @errorMsg = 'Info: Starting cleanup process'
RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
-- Database
IF EXISTS (
	SELECT 1 FROM master.sys.databases WHERE name = @dbname
)
BEGIN
	SET @cmd = 'DROP DATABASE ' + @dbname + ';'
	BEGIN TRY
		EXEC sp_executesql @cmd
		SET @errorMsg = 'Info: Database "' + @dbname + '" dropped'
		RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
	END TRY
	BEGIN CATCH
		SET @errorMsg = 'Error: Could not drop database "' + @dbname + '"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
		SET @errCount += 1
		RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
		RETURN;
	END CATCH
END

-- Jobs - 01_MAINT_BACKUP_FULL
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '01_MAINT_BACKUP_FULL'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '01_MAINT_BACKUP_FULL'
	SET @errorMsg = 'Info: Job "01_MAINT_BACKUP_FULL" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 02_MAINT_BACKUP_DIFF
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '02_MAINT_BACKUP_DIFF'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '02_MAINT_BACKUP_DIFF'
	SET @errorMsg = 'Info: Job "02_MAINT_BACKUP_DIFF" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 03_MAINT_BACKUP_LOG
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '03_MAINT_BACKUP_LOG'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '03_MAINT_BACKUP_LOG'
	SET @errorMsg = 'Info: Job "03_MAINT_BACKUP_LOG" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 04_MAINT_INDEX_STATS
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '04_MAINT_INDEX_STATS'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '04_MAINT_INDEX_STATS'
	SET @errorMsg = 'Info: Job "04_MAINT_INDEX_STATS" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 05_MAINT_CHECKDB
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '05_MAINT_CHECKDB'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '05_MAINT_CHECKDB'
	SET @errorMsg = 'Info: Job "05_MAINT_CHECKDB" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 06_MAINT_BACKUP_LOGINS
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '06_MAINT_BACKUP_LOGINS'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '06_MAINT_BACKUP_LOGINS'
	SET @errorMsg = 'Info: Job "06_MAINT_BACKUP_LOGINS" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 07_MAINT_BACKUP_AGENTJOBS
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '07_MAINT_BACKUP_AGENTJOBS'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '07_MAINT_BACKUP_AGENTJOBS'
	SET @errorMsg = 'Info: Job "07_MAINT_BACKUP_AGENTJOBS" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 08_MAINT_CLEANUP_TASKS
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '08_MAINT_CLEANUP_TASKS'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '08_MAINT_CLEANUP_TASKS'
	SET @errorMsg = 'Info: Job "08_MAINT_CLEANUP_TASKS" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END

-- Jobs - 06_MAINT_BACKUP_OBJECTS
IF EXISTS (
	SELECT 1 FROM msdb.dbo.sysjobs WHERE name = '06_MAINT_BACKUP_OBJECTS'
)
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name = '06_MAINT_BACKUP_OBJECTS'
	SET @errorMsg = 'Info: Job "06_MAINT_BACKUP_OBJECTS" dropped'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END


SET @errorMsg = 'Info: Cleanup process finished'
RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;

-- END: Cleanup


-- START: CREATE DATABASE
SET @errorMsg = 'Info: Starting installation process'
RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;

IF EXISTS (
	SELECT 1 FROM master.sys.databases WHERE name = @dbname
)
BEGIN
	SET @errorMsg = 'Error: Database "' + @dbname + '" already exists - please specify a database name that does not exist'
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END
ELSE
BEGIN
	SET @cmd = 'CREATE DATABASE [' + @dbname + '];'
	BEGIN TRY
		EXEC sp_executesql @cmd
		SET @errorMsg = 'Info: Database "' + @dbname + '" created'
		RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
	END TRY
	BEGIN CATCH
		SET @errorMsg = 'Error: Could not create database "' + @dbname +'"' + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
		RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
		RETURN;
	END CATCH
	
	-- Set SIMPLE Recovery Model
	SET @cmd = 'ALTER DATABASE [' + @dbname + '] SET RECOVERY SIMPLE WITH NO_WAIT;'
	BEGIN TRY
		EXEC sp_executesql @cmd
		SET @errorMsg = 'Info: Recovery Model set to "SIMPLE" for database "' + @dbname + '"'
		RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
	END TRY
	BEGIN CATCH
		SET @errorMsg = 'Error: Could not change recovery model to "SIMPLE" for database "' + @dbname + '"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
		RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
		RETURN;
	END CATCH
END

-- END: CREATE DATABASE

-- START: CREATE SCHEMA

SET @cmd = 'CREATE SCHEMA [CONFIG];'
BEGIN TRY
	EXEC('USE ' + @dbname + '; EXEC sp_executesql N''' + @cmd + ''' ')
	SET @errorMsg = 'Info: Schema "CONFIG" created'
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create schema "CONFIG"' + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH
		
-- END: CREATE SCHEMA

-- START: CREATE TABLES

-- tblDatabaseBackupDiff
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff](
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
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
'

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblDatabaseBackupDiff" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblDatabaseBackupDiff"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Databases'', N''ALL_DATABASES'', N''NVARCHAR(MAX)'', N''Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Directory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupType'', N''DIFF'', N''NVARCHAR(MAX)'', N''Specify the type of backup: full, differential, or transaction log.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Verify'', N''N'', N''NVARCHAR(MAX)'', N''Verify the backup'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupTime'', N''168'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted. Default is 168 hours (7 days). If no time is specified, then no backup files are deleted. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Compress'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CopyOnly'', N''N'', N''NVARCHAR(MAX)'', N''Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ChangeBackupType'', N''Y'', N''NVARCHAR(MAX)'', N''Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead. DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupSoftware'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify third-party backup software; otherwise, SQL Server native backup is performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CheckSum'', N''N'', N''NVARCHAR(MAX)'', N''Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BlockSize'', N''[NULL]'', N''INT'', N''Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BufferCount'', N''[NULL]'', N''INT'', N''Specify the number of I/O buffers to be used for the backup operation. The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxTransferSize'', N''[NULL]'', N''INT'', N''Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media. The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NumberOfFiles'', N''[NULL]'', N''INT'', N''Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MinBackupSizeForMultipleFiles'', N''[NULL]'', N''INT'', N''Specify a minimum backup size in MB, for when DatabaseBackup should back up to multiple files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxFileSize'', N''[NULL]'', N''INT'', N''Specify a maximum backup file size in MB. DatabaseBackup will dynamically calculate the number of backup files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CompressionLevel'', N''[NULL]'', N''INT'', N''Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level. In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Description'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Enter a description for the backup. The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Threads'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Throttle'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Encrypt'', N''N'', N''NVARCHAR(MAX)'', N''Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionAlgorithm'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the type of encryption. The EncryptionAlrithm option in DatabaseBackup uses the ENCRYPTION and ALRITHM options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerCertificate'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Server certificate that is used to encrypt the backup. The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerAsymmetricKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Asymmetric key that is used to encrypt the backup. The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. '', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ReadWriteFileGroups'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the primary filegroup and any read/write filegroups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@OverrideBackupPreference'', N''N'', N''NVARCHAR(MAX)'', N''Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NoRecovery'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@URL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the domain name and container for backup to Azure Blob Storage. The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Credential'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify a CREDENTIAL for backup to Windows Azure Blob Storage. The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorDirectory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify one or multiple directories to perform a mirrored backup. The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupTime'', N''[NULL]'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted. By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorURL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the URL for a mirrored backup to Azure Blob Storage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Updateability'', N''ALL'', N''NVARCHAR(MAX)'', N''Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ModificationLevel'', N''[NULL]'', N''INT'', N''Specify a percentage when a differential backup will be changed to a full backup. This option can only be used together with @ChangeBackupType = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogSizeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum size (MB) for the amount of log that has been generated since the last log backup. This option can only be used together with @TimeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TimeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum time, in seconds, since the last log backup. This option can only be used together with @LogSizeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostHost'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain server.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostUser'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain user.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostDevicePath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name and the path of the Data Domain storage unit.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostLockboxPath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the folder that contains the Data Domain lockbox file.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DirectoryStructure'', N''{ServerName}${InstanceName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupDirectoryStructure'', N''{ClusterName}${AvailabilityGroupName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileName'', N''{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupFileName'', N''{ClusterName}${AvailabilityGroupName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionFull'', N''bak'', N''NVARCHAR(MAX)'', N''Specify the file extension for full backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionDiff'', N''diff'', N''NVARCHAR(MAX)'', N''Specify the file extension for differential backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionLog'', N''trn'', N''NVARCHAR(MAX)'', N''Specify the file extension for log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Init'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether the backup file should be overwritten.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Format'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether a new media header should be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ObjectLevelRecoveryMap'', N''N'', N''NVARCHAR(MAX)'', N''Generate a map file during a backup for Object Level Recovery. This option is only supported in LiteSpeed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ExcludeLogShippedFromLogBackup'', N''Y'', N''NVARCHAR(MAX)'', N''Exclude databases configured for Log Shipping, from log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StringDelimiter'', N'','', N''NVARCHAR(MAX)'', N''Specify the string delimiter. By default, the string delimiter is comma.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabaseOrder'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the database order.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabasesInParallel'', N''N'', N''NVARCHAR(MAX)'', N''You can process databases in parallel by creating multiple jobs with the same parameters, and add the parameter @DatabasesInParallel = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogToTable'', N''Y'', N''NVARCHAR(MAX)'', N''Log commands to the table dbo.CommandLog.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupDiff] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Execute'', N''Y'', N''NVARCHAR(MAX)'', N''Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.'', CAST(N''2020-12-31'' AS Date));
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblDatabaseBackupDiff" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblDatabaseBackupDiff"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: CONF TABLE - DIFF BACKUP

-- START: tblDatabaseBackupFull
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull](
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
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblDatabaseBackupFull" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblDatabaseBackupFull"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Databases'', N''ALL_DATABASES'', N''NVARCHAR(MAX)'', N''Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Directory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupType'', N''FULL'', N''NVARCHAR(MAX)'', N''Specify the type of backup: full, differential, or transaction log.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Verify'', N''N'', N''NVARCHAR(MAX)'', N''Verify the backup'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupTime'', N''720'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted. Default is 720 hours (30 days). If no time is specified, then no backup files are deleted. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Compress'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CopyOnly'', N''N'', N''NVARCHAR(MAX)'', N''Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ChangeBackupType'', N''Y'', N''NVARCHAR(MAX)'', N''Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead. DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupSoftware'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify third-party backup software; otherwise, SQL Server native backup is performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CheckSum'', N''N'', N''NVARCHAR(MAX)'', N''Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BlockSize'', N''[NULL]'', N''INT'', N''Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BufferCount'', N''[NULL]'', N''INT'', N''Specify the number of I/O buffers to be used for the backup operation. The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxTransferSize'', N''[NULL]'', N''INT'', N''Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media. The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NumberOfFiles'', N''4'', N''INT'', N''Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MinBackupSizeForMultipleFiles'', N''[NULL]'', N''INT'', N''Specify a minimum backup size in MB, for when DatabaseBackup should back up to multiple files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxFileSize'', N''[NULL]'', N''INT'', N''Specify a maximum backup file size in MB. DatabaseBackup will dynamically calculate the number of backup files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CompressionLevel'', N''[NULL]'', N''INT'', N''Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level. In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Description'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Enter a description for the backup. The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Threads'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Throttle'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Encrypt'', N''N'', N''NVARCHAR(MAX)'', N''Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionAlgorithm'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the type of encryption. The EncryptionAlrithm option in DatabaseBackup uses the ENCRYPTION and ALRITHM options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerCertificate'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Server certificate that is used to encrypt the backup. The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerAsymmetricKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Asymmetric key that is used to encrypt the backup. The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. '', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ReadWriteFileGroups'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the primary filegroup and any read/write filegroups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@OverrideBackupPreference'', N''N'', N''NVARCHAR(MAX)'', N''Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NoRecovery'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@URL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the domain name and container for backup to Azure Blob Storage. The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Credential'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify a CREDENTIAL for backup to Windows Azure Blob Storage. The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorDirectory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify one or multiple directories to perform a mirrored backup. The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupTime'', N''[NULL]'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted. By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorURL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the URL for a mirrored backup to Azure Blob Storage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Updateability'', N''ALL'', N''NVARCHAR(MAX)'', N''Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ModificationLevel'', N''[NULL]'', N''INT'', N''Specify a percentage when a differential backup will be changed to a full backup. This option can only be used together with @ChangeBackupType = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogSizeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum size (MB) for the amount of log that has been generated since the last log backup. This option can only be used together with @TimeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TimeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum time, in seconds, since the last log backup. This option can only be used together with @LogSizeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostHost'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain server.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostUser'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain user.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostDevicePath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name and the path of the Data Domain storage unit.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostLockboxPath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the folder that contains the Data Domain lockbox file.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DirectoryStructure'', N''{ServerName}${InstanceName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupDirectoryStructure'', N''{ClusterName}${AvailabilityGroupName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileName'', N''{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupFileName'', N''{ClusterName}${AvailabilityGroupName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionFull'', N''bak'', N''NVARCHAR(MAX)'', N''Specify the file extension for full backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionDiff'', N''diff'', N''NVARCHAR(MAX)'', N''Specify the file extension for differential backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionLog'', N''trn'', N''NVARCHAR(MAX)'', N''Specify the file extension for log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Init'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether the backup file should be overwritten.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Format'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether a new media header should be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ObjectLevelRecoveryMap'', N''N'', N''NVARCHAR(MAX)'', N''Generate a map file during a backup for Object Level Recovery. This option is only supported in LiteSpeed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ExcludeLogShippedFromLogBackup'', N''Y'', N''NVARCHAR(MAX)'', N''Exclude databases configured for Log Shipping, from log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StringDelimiter'', N'','', N''NVARCHAR(MAX)'', N''Specify the string delimiter. By default, the string delimiter is comma.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabaseOrder'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the database order.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabasesInParallel'', N''N'', N''NVARCHAR(MAX)'', N''You can process databases in parallel by creating multiple jobs with the same parameters, and add the parameter @DatabasesInParallel = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogToTable'', N''Y'', N''NVARCHAR(MAX)'', N''Log commands to the table dbo.CommandLog.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupFull] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Execute'', N''Y'', N''NVARCHAR(MAX)'', N''Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.'', CAST(N''2020-12-31'' AS Date));
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblDatabaseBackupFull" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblDatabaseBackupFull"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: tblDatabaseBackupFull

-- START: tblDatabaseBackupLog
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog](
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
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblDatabaseBackupLog" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblDatabaseBackupLog"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Databases'', N''ALL_DATABASES'', N''NVARCHAR(MAX)'', N''Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Directory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify backup root directories, which can be local directories or network shares. If you specify multiple directories, then the backup files are striped evenly across the directories. Specify multiple directories by using the comma (,). If no directory is specified, then the SQL Server default backup directory is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupType'', N''LOG'', N''NVARCHAR(MAX)'', N''Specify the type of backup: full, differential, or transaction log.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Verify'', N''N'', N''NVARCHAR(MAX)'', N''Verify the backup'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupTime'', N''720'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted. Default is 720 hours (30 days). If no time is specified, then no backup files are deleted. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Compress'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Compress the backup. If no value is specified, then the backup compression default in sys.configurations is used.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CopyOnly'', N''N'', N''NVARCHAR(MAX)'', N''Perform a copy-only backup. The CopyOnly option in DatabaseBackup uses the COPY_ONLY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ChangeBackupType'', N''Y'', N''NVARCHAR(MAX)'', N''Change the backup type if a differential or transaction-log backup cannot be performed. DatabaseBackup checks differential_base_lsn in sys.master_files to determine whether a differential backup can be performed. If a differential backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a full backup performed instead. DatabaseBackup checks last_log_backup_lsn in sys.database_recovery_status to determine whether a transaction log backup in full or bulk-logged recovery model can be performed. If a transaction log backup is not possible, then the database is skipped by default. Alternatively, you can set ChangeBackupType to Y to have a differential or full backup performed instead.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BackupSoftware'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify third-party backup software; otherwise, SQL Server native backup is performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CheckSum'', N''N'', N''NVARCHAR(MAX)'', N''Enable backup checksums. The CheckSum option in DatabaseBackup uses the CHECKSUM option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BlockSize'', N''[NULL]'', N''INT'', N''Specify the physical blocksize in bytes. The BlockSize option in DatabaseBackup uses the BLOCKSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@BufferCount'', N''[NULL]'', N''INT'', N''Specify the number of I/O buffers to be used for the backup operation. The BufferCount option in DatabaseBackup uses the BUFFERCOUNT option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxTransferSize'', N''[NULL]'', N''INT'', N''Specify the largest unit of transfer, in bytes, to be used between SQL Server and the backup media. The MaxTransferSize option in DatabaseBackup uses the MAXTRANSFERSIZE option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NumberOfFiles'', N''1'', N''INT'', N''Specify the number of backup files. The default is the number of backup directories and the maximum is 64 files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MinBackupSizeForMultipleFiles'', N''[NULL]'', N''INT'', N''Specify a minimum backup size in MB, for when DatabaseBackup should back up to multiple files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxFileSize'', N''[NULL]'', N''INT'', N''Specify a maximum backup file size in MB. DatabaseBackup will dynamically calculate the number of backup files.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CompressionLevel'', N''[NULL]'', N''INT'', N''Set the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup compression level. In LiteSpeed for SQL Server, the compression levels 0 to 8 are supported. In Red Gate SQL Backup Pro, levels 0 to 4 are supported, and in Idera SQL Safe Backup, levels 1 to 4 are supported.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Description'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Enter a description for the backup. The Description option in DatabaseBackup uses the DESCRIPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Threads'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server, Red Gate SQL Backup Pro, or Idera SQL Safe Backup number of threads. The maximum number of threads is 32.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Throttle'', N''[NULL]'', N''INT'', N''Specify the LiteSpeed for SQL Server maximum CPU usage, as a percentage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Encrypt'', N''N'', N''NVARCHAR(MAX)'', N''Encrypt the backup. The Encrypt option in DatabaseBackup uses the ENCRYPTION option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionAlgorithm'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the type of encryption. The EncryptionAlrithm option in DatabaseBackup uses the ENCRYPTION and ALRITHM options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerCertificate'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Server certificate that is used to encrypt the backup. The ServerCertificate option in DatabaseBackup uses the ENCRYPTION and SERVER CERTIFICATE options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ServerAsymmetricKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Asymmetric key that is used to encrypt the backup. The ServerAsymmetricKey option in DatabaseBackup uses the ENCRYPTION and SERVER ASYMMETRIC KEY options in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@EncryptionKey'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Key that is used to encrypt the backup. This is used with LiteSpeed for SQL Server, Red Gate SQL Backup Pro, and Idera SQL Safe Backup. '', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ReadWriteFileGroups'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the primary filegroup and any read/write filegroups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@OverrideBackupPreference'', N''N'', N''NVARCHAR(MAX)'', N''Override the backup preference for availability groups. This option only applies to copy-only full backups and regular transaction log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NoRecovery'', N''N'', N''NVARCHAR(MAX)'', N''Perform a backup of the tail of the log and leave the database in the RESTORING state. The NoRecovery option in DatabaseBackup uses the NORECOVERY option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@URL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the domain name and container for backup to Azure Blob Storage. The URL option in DatabaseBackup uses the URL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Credential'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify a CREDENTIAL for backup to Windows Azure Blob Storage. The Credential option in DatabaseBackup uses the CREDENTIAL option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorDirectory'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify one or multiple directories to perform a mirrored backup. The MirrorDirectory option in DatabaseBackup uses the MIRROR TO option in the SQL Server BACKUP command.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupTime'', N''[NULL]'', N''INT'', N''Specify the time, in hours, after which the backup files are deleted in the mirror directories. If no time is specified, then no backup files are deleted. By default backup files are deleted after each database is backed up and verified. Backup files are deleted only if the backup and verification of the database were successful. DatabaseBackup has a check to verify that transaction log backups that are newer than the most recent full or differential backup are not deleted. This is to guarantee that you can always perform a point-in-time restore.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorCleanupMode'', N''AFTER_BACKUP'', N''NVARCHAR(MAX)'', N''Specify if old backup files in the mirror directory should be deleted before or after the backup has been performed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MirrorURL'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the URL for a mirrored backup to Azure Blob Storage.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Updateability'', N''ALL'', N''NVARCHAR(MAX)'', N''Select READ_ONLY/READ_WRITE - databases. is_read_only in sys.databases is used to check if a database is READ_ONLY or READ_WRITE.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ModificationLevel'', N''[NULL]'', N''INT'', N''Specify a percentage when a differential backup will be changed to a full backup. This option can only be used together with @ChangeBackupType = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogSizeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum size (MB) for the amount of log that has been generated since the last log backup. This option can only be used together with @TimeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TimeSinceLastLogBackup'', N''[NULL]'', N''INT'', N''Specify a minimum time, in seconds, since the last log backup. This option can only be used together with @LogSizeSinceLastLogBackup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostHost'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain server.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostUser'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name of the Data Domain user.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostDevicePath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the name and the path of the Data Domain storage unit.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataDomainBoostLockboxPath'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the folder that contains the Data Domain lockbox file.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DirectoryStructure'', N''{ServerName}${InstanceName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupDirectoryStructure'', N''{ClusterName}${AvailabilityGroupName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup. If the parameter is set to NULL, no sub-directories will be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileName'', N''{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupFileName'', N''{ClusterName}${AvailabilityGroupName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'', N''NVARCHAR(MAX)'', N''Tokens that do not apply will be removed. E.g. the token {CopyOnly} (and the associated _) will be removed if it is not a copy-only backup.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionFull'', N''bak'', N''NVARCHAR(MAX)'', N''Specify the file extension for full backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionDiff'', N''diff'', N''NVARCHAR(MAX)'', N''Specify the file extension for differential backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileExtensionLog'', N''trn'', N''NVARCHAR(MAX)'', N''Specify the file extension for log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Init'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether the backup file should be overwritten.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Format'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether a new media header should be created.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ObjectLevelRecoveryMap'', N''N'', N''NVARCHAR(MAX)'', N''Generate a map file during a backup for Object Level Recovery. This option is only supported in LiteSpeed.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ExcludeLogShippedFromLogBackup'', N''Y'', N''NVARCHAR(MAX)'', N''Exclude databases configured for Log Shipping, from log backups.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StringDelimiter'', N'','', N''NVARCHAR(MAX)'', N''Specify the string delimiter. By default, the string delimiter is comma.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabaseOrder'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the database order.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabasesInParallel'', N''N'', N''NVARCHAR(MAX)'', N''You can process databases in parallel by creating multiple jobs with the same parameters, and add the parameter @DatabasesInParallel = Y.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogToTable'', N''Y'', N''NVARCHAR(MAX)'', N''Log commands to the table dbo.CommandLog.'', CAST(N''2020-12-31'' AS Date));
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseBackupLog] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Execute'', N''Y'', N''NVARCHAR(MAX)'', N''Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.'', CAST(N''2020-12-31'' AS Date));
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblDatabaseBackupLog" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblDatabaseBackupLog"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: tblDatabaseBackupLog

-- START: tblDatabaseIntegrityCheck
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck](
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
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblDatabaseIntegrityCheck" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblDatabaseIntegrityCheck"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Databases'', N''ALL_DATABASES'', N''NVARCHAR(MAX)'', N''Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@CheckCommands'', N''CHECKDB'', N''NVARCHAR(MAX)'', N''DatabaseIntegrityCheck uses these SQL Server DBCC commands: DBCC CHECKDB to check the database, DBCC CHECKFILEGROUP to check the filegroups, DBCC CHECKTABLE to check the tables and the indexed views, DBCC CHECKALLOC to check the disk space allocation structures, and DBCC CHECKCATALOG to check the catalog consistency.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@PhysicalOnly'', N''N'', N''NVARCHAR(MAX)'', N''The PhysicalOnly option in DatabaseIntegrityCheck uses the PHYSICAL_ONLY option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, and DBCC CHECKTABLE commands.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DataPurity'', N''N'', N''NVARCHAR(MAX)'', N''Check for column values that are not valid or out-of-range.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@NoIndex'', N''N'', N''NVARCHAR(MAX)'', N''The NoIndex option in DatabaseIntegrityCheck uses the NOINDEX option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, DBCC CHECKTABLE, and DBCC CHECKALLOC commands.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ExtendedLogicalChecks'', N''N'', N''NVARCHAR(MAX)'', N''The ExtendedLogicalChecks option in DatabaseIntegrityCheck uses the EXTENDED_LOGICAL_CHECKS option in the SQL Server DBCC CHECKDB command. You cannot combine the options PhysicalOnly and ExtendedLogicalChecks.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TabLock'', N''N'', N''NVARCHAR(MAX)'', N''The TabLock option in DatabaseIntegrityCheck uses the TABLOCK option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, DBCC CHECKTABLE, and DBCC CHECKALLOC commands.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FileGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select filegroups. The ALL_FILEGROUPS keyword is supported. The hyphen character (-) is used to exclude filegroups, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Objects'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select objects. The ALL_OBJECTS keyword is supported. The hyphen character (-) is used to exclude objects, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxDOP'', N''[NULL]'', N''INT'', N''Specify the number of CPUs to use when checking the database, filegroup or table. If this number is not specified, the global maximum degree of parallelism is used. The MaxDOP option in DatabaseIntegrityCheck uses the MAXDOP option in the SQL Server DBCC CHECKDB, DBCC CHECKFILEGROUP, and DBCC CHECKTABLE commands.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroupReplicas'', N''ALL'', N''NVARCHAR(MAX)'', N''Specify which replicas in availability groups that should be checked.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Updateability'', N''ALL'', N''NVARCHAR(MAX)'', N''Select READ_ONLY/READ_WRITE - databases.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TimeLimit'', N''[NULL]'', N''INT'', N''Set the time, in seconds, after which no commands are executed. By default, the time is not limited.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LockTimeout'', N''[NULL]'', N''INT'', N''Set the time, in seconds, that a command waits for a lock to be released. By default, the time is not limited. The LockTimeout option in IndexOptimize uses the SET LOCK_TIMEOUT set statement in SQL Server.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LockMessageSeverity'', N''16'', N''INT'', N''Set the severity for lock timeouts and deadlocks.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StringDelimiter'', N'','', N''NVARCHAR(MAX)'', N''Specify the string delimiter. By default, the string delimiter is comma.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabaseOrder'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the database order.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabasesInParallel'', N''N'', N''NVARCHAR(MAX)'', N''Process databases in parallel.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogToTable'', N''Y'', N''NVARCHAR(MAX)'', N''Log commands to the table dbo.CommandLog.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblDatabaseIntegrityCheck] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Execute'', N''Y'', N''NVARCHAR(MAX)'', N''Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.'', CAST(N''2020-12-31'' AS Date))	
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblDatabaseIntegrityCheck" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblDatabaseIntegrityCheck"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: tblDatabaseIntegrityCheck

-- START: tblIndexOptimize

SET @cmd = '
CREATE TABLE [' + @dbname + '].[CONFIG].[tblIndexOptimize](
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
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblIndexOptimize" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblIndexOptimize"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Databases'', N''ALL_DATABASES'', N''NVARCHAR(MAX)'', N''Select databases. The keywords SYSTEM_DATABASES, USER_DATABASES, ALL_DATABASES, and AVAILABILITY_GROUP_DATABASES are supported. The hyphen character (-) is used to exclude databases, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FragmentationLow'', N''[NULL]'', N''NVARCHAR(MAX)'', N''An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained. IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FragmentationMedium'', N''INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'', N''NVARCHAR(MAX)'', N''An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained. IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FragmentationHigh'', N''INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'', N''NVARCHAR(MAX)'', N''An online index rebuild or an index reorganization is not always possible. Because of this, you can specify multiple index-maintenance operations for each fragmentation group. These operations are prioritized from left to right: If the first operation is supported for the index, then that operation is used; if the first operation is not supported, then the second operation is used (if supported), and so on. If none of the specified operations are supported for an index, then that index is not maintained. IndexOptimize uses the SQL Server ALTER INDEX command: REBUILD WITH (ONLINE = ON) to rebuild indexes online, REBUILD WITH (ONLINE = OFF) to rebuild indexes offline, and REORGANIZE to reorganize indexes.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FragmentationLevel1'', N''5'', N''INT'', N''Set the lower limit, as a percentage, for medium fragmentation. The default is 5 percent. This is based on Microsoft’s recommendation in Books Online. IndexOptimize checks avg_fragmentation_in_percent in sys.dm_db_index_physical_stats to determine the fragmentation.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FragmentationLevel2'', N''30'', N''INT'', N''Set the lower limit, as a percentage, for high fragmentation. The default is 30 percent. This is based on Microsoft’s recommendation in Books Online. IndexOptimize checks avg_fragmentation_in_percent in sys.dm_db_index_physical_stats to determine the fragmentation.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MinNumberOfPages'', N''1000'', N''INT'', N''Set a size, in pages; indexes with fewer pages are skipped for index maintenance. The default is 1000 pages. This is based on Microsoft’s recommendation. IndexOptimize checks page_count in sys.dm_db_index_physical_stats to determine the size of the index.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxNumberOfPages'', N''[NULL]'', N''INT'', N''Set a size, in pages; indexes with greater number of pages are skipped for index maintenance. The default is no limitation.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@SortInTempdb'', N''Y'', N''NVARCHAR(MAX)'', N''The SortInTempdb option in IndexOptimize uses the SORT_IN_TEMPDB option in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MaxDOP'', N''[NULL]'', N''INT'', N''Specify the number of CPUs to use when rebuilding indexes. If this number is not specified, the global maximum degree of parallelism is used. The MaxDOP option in IndexOptimize uses the MAXDOP option in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@FillFactor'', N''95'', N''INT'', N''Indicate, as a percentage, how full the pages should be made when rebuilding indexes. If a percentage is not specified, the fill factor in sys.indexes is used. The FillFactor option in IndexOptimize uses the FILLFACTOR option in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@PadIndex'', N''N'', N''NVARCHAR(MAX)'', N''Apply the percentage of free space that the fill factor specifies to the intermediate-level pages of the index.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LOBCompaction'', N''Y'', N''NVARCHAR(MAX)'', N''The LOBCompaction option in IndexOptimize uses the LOB_COMPACTION option in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@UpdateStatistics'', N''ALL'', N''NVARCHAR(MAX)'', N''IndexOptimize uses the SQL Server UPDATE STATISTICS command to update statistics.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@OnlyModifiedStatistics'', N''Y'', N''NVARCHAR(MAX)'', N''Update statistics only if any rows have been modified since the most recent statistics update.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StatisticsModificationLevel'', N''[NULL]'', N''INT'', N''Specify a percentage of modified rows for when the statistics should be updated. Statistics will also be updated when the number of modified rows has reached a decreasing, dynamic threshold, SQRT(number of rows * 1000).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StatisticsSample'', N''[NULL]'', N''INT'', N''Indicate, as a percentage, how much of a table is gathered when updating statistics. A value of 100 is equivalent to a full scan. If no value is specified, then SQL Server automatically computes the required sample. The StatisticsSample option in IndexOptimize uses the SAMPLE and FULLSCAN options in the SQL Server UPDATE STATISTICS command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StatisticsResample'', N''N'', N''NVARCHAR(MAX)'', N''The StatisticsResample option in IndexOptimize uses the RESAMPLE option in the SQL Server UPDATE STATISTICS command. You cannot combine the options StatisticsSample and StatisticsResample.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@PartitionLevel'', N''Y'', N''NVARCHAR(MAX)'', N''Maintain partitioned indexes on the partition level. If this parameter is set to Y, the fragmentation level and page count is checked for each partition. The appropriate index maintenance (reorganize or rebuild) is then performed for each partition.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@MSShippedObjects'', N''N'', N''NVARCHAR(MAX)'', N''Maintain indexes and statistics on objects that are created by internal SQL Server components.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Indexes'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select indexes. If this parameter is not specified, all indexes are selected. The ALL_INDEXES keyword is supported. The hyphen character (-) is used to exclude indexes, and the percent character (%) is used for wildcard selection. All these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@TimeLimit'', N''[NULL]'', N''INT'', N''Set the time, in seconds, after which no commands are executed. By default, the time is not limited.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Delay'', N''[NULL]'', N''INT'', N''Set the delay, in seconds, between index commands. By default, there is no delay.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@WaitAtLowPriorityMaxDuration'', N''[NULL]'', N''INT'', N''The time, in minutes that an online index rebuild operation will wait for low priority locks. The WaitAtLowPriorityMaxDuration option in IndexOptimize uses the WAIT_AT_LOW_PRIORITY and MAX_DURATION options in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@WaitAtLowPriorityAbortAfterWait'', N''[NULL]'', N''NVARCHAR(MAX)'', N''The WaitAtLowPriorityAbortAfterWait option in IndexOptimize uses the WAIT_AT_LOW_PRIORITY and ABORT_AFTER_WAIT options in the SQL Server ALTER INDEX command.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Resumable'', N''N'', N''NVARCHAR(MAX)'', N''Specify whether an online index operation is resumable.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@AvailabilityGroups'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Select availability groups. The keyword ALL_AVAILABILITY_GROUPS is supported. The hyphen character (-) is used to exclude availability groups, and the percent character (%) is used for wildcard selection. All of these operations can be combined by using the comma (,).'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LockTimeout'', N''[NULL]'', N''INT'', N''Set the time, in seconds, that a command waits for a lock to be released. By default, the time is not limited. The LockTimeout option in IndexOptimize uses the SET LOCK_TIMEOUT set statement in SQL Server.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LockMessageSeverity'', N''16'', N''INT'', N''Set the severity for lock timeouts and deadlocks.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@StringDelimiter'', N'','', N''NVARCHAR(MAX)'', N''Specify the string delimiter. By default, the string delimiter is comma.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabaseOrder'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Specify the database order.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@DatabasesInParallel'', N''N'', N''NVARCHAR(MAX)'', N''Process databases in parallel.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@ExecuteAsUser'', N''[NULL]'', N''NVARCHAR(MAX)'', N''Change the execution context to a user. The user can be dbo or any other user. The user has to exist in all databases that you are working with.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@LogToTable'', N''Y'', N''NVARCHAR(MAX)'', N''Log commands to the table dbo.CommandLog.'', CAST(N''2020-12-31'' AS Date))
	INSERT INTO [' + @dbname + '].[CONFIG].[tblIndexOptimize] ([Parameter], [Value], [ValueDataType], [Description], [ScriptRelease]) VALUES (N''@Execute'', N''Y'', N''NVARCHAR(MAX)'', N''Execute commands. By default, the commands are executed normally. If this parameter is set to N, then the commands are printed only.'', CAST(N''2020-12-31'' AS Date))
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblIndexOptimize" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblIndexOptimize"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: tblIndexOptimize

-- START: tblCleanup
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[CONFIG].[tblCleanup](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[ObjectName] [nvarchar](256) NOT NULL,
		[CleanupDays] [int] NOT NULL,
	 CONSTRAINT [PK_tblCleanup] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY];
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "tblCleanup" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "tblCleanup"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

SET @cmd = '
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''CommandLog'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''BackupAlerts'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''BackupOperators'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''BackupJobs'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''BackupLogins'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''BackupHistory'', 30)
	INSERT INTO [' + @dbname + '].[CONFIG].[tblCleanup] ([ObjectName], [CleanupDays]) VALUES (N''JobHistory'', 30)
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Insert default values to table "tblCleanup" successful'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not insert default values to table "tblCleanup"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT
	RETURN;
END CATCH

-- END: tblCleanup

-- START: BackupJobs

SET @cmd = '
CREATE TABLE [' + @dbname + '].[dbo].[BackupJobs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[RunDate] [datetime] NOT NULL,
	[JobName] [nvarchar](128) NOT NULL,
	[CreateJobStatement] [nvarchar](max) NOT NULL, 
 CONSTRAINT [PK_tblBackupJobs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "BackupJobs" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "BackupJobs"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

-- END: BackupJobs

-- START: BackupLogins

SET @cmd = '
	CREATE TABLE [' + @dbname + '].[dbo].[BackupLogins](
		[id] [bigint] IDENTITY(1,1) NOT NULL,
		[RunDate] [datetime] NOT NULL,
		[LoginName] [nvarchar](128) NOT NULL,
		[CreateStatement] [nvarchar](max) NOT NULL,
	 CONSTRAINT [PK_BackupLogins] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
';

BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "BackupLogins" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "BackupLogins"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

-- END: BackupLogins

-- Start: BackupOperators

SET @cmd = '
	CREATE TABLE [' + @dbname + '].[dbo].[BackupOperators](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[RunDate] [datetime] NOT NULL,
		[OperatorName] [nvarchar](128) NOT NULL,
		[CreateStatement] [nvarchar](max) NOT NULL,
	 CONSTRAINT [PK_BackupOperators] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
';
BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "BackupOperators" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "BackupOperators"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH

-- END: BackupOperators

-- Start: BackupAlerts
SET @cmd = '
	CREATE TABLE [' + @dbname + '].[dbo].[BackupAlerts](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[RunDate] [datetime] NOT NULL,
		[AlertName] [nvarchar](128) NOT NULL,
		[CreateStatement] [nvarchar](max) NOT NULL,
	 CONSTRAINT [PK_BackupAlerts] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
';
BEGIN TRY
	EXEC sp_executesql @cmd
	SET @errorMsg = 'Info: Table "BackupAlerts" created'
	RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SET @errorMsg = 'Error: Could not create table "BackupAlerts"' + CHAR(10) + CHAR(13) + ERROR_MESSAGE()
	RAISERROR(@errorMsg, 16, 1) WITH NOWAIT;
	RETURN;
END CATCH
-- End: BackupAlerts



GO
--############################################################################################################################################
-- START: OLA HALLENGREN SCRIPT
--############################################################################################################################################
/*

SQL Server Maintenance Solution - SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, SQL Server 2016, SQL Server 2017, and SQL Server 2019

Backup: https://ola.hallengren.com/sql-server-backup.html
Integrity Check: https://ola.hallengren.com/sql-server-integrity-check.html
Index and Statistics Maintenance: https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html

License: https://ola.hallengren.com/license.html

GitHub: https://github.com/olahallengren/sql-server-maintenance-solution

Version: 2020-12-31 18:58:56

You can contact me by e-mail at ola@hallengren.com.

Ola Hallengren
https://ola.hallengren.com

*/

USE $(DATABASE_NAME); -- Specify the database in which the objects will be created.

SET NOCOUNT ON

DECLARE @CreateJobs nvarchar(max)          = 'N'         -- Specify whether jobs should be created.
DECLARE @BackupDirectory nvarchar(max)     = NULL        -- Specify the backup root directory. If no directory is specified, the default backup directory is used.
DECLARE @CleanupTime int                   = NULL        -- Time in hours, after which backup files are deleted. If no time is specified, then no backup files are deleted.
DECLARE @OutputFileDirectory nvarchar(max) = NULL        -- Specify the output file directory. If no directory is specified, then the SQL Server error log directory is used.
DECLARE @LogToTable nvarchar(max)          = 'Y'         -- Log commands to a table.

DECLARE @ErrorMessage nvarchar(max)

IF IS_SRVROLEMEMBER('sysadmin') = 0 AND NOT (DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa')
BEGIN
  SET @ErrorMessage = 'You need to be a member of the SysAdmin server role to install the SQL Server Maintenance Solution.'
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
END

IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
BEGIN
  SET @ErrorMessage = 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.'
  RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
END

IF OBJECT_ID('tempdb..#Config') IS NOT NULL DROP TABLE #Config

CREATE TABLE #Config ([Name] nvarchar(max),
                      [Value] nvarchar(max))

INSERT INTO #Config ([Name], [Value]) VALUES('CreateJobs', @CreateJobs)
INSERT INTO #Config ([Name], [Value]) VALUES('BackupDirectory', @BackupDirectory)
INSERT INTO #Config ([Name], [Value]) VALUES('CleanupTime', @CleanupTime)
INSERT INTO #Config ([Name], [Value]) VALUES('OutputFileDirectory', @OutputFileDirectory)
INSERT INTO #Config ([Name], [Value]) VALUES('LogToTable', @LogToTable)
INSERT INTO #Config ([Name], [Value]) VALUES('DatabaseName', DB_NAME(DB_ID()))
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommandLog]') AND type in (N'U'))
BEGIN
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
  [StartTime] [datetime2](7) NOT NULL,
  [EndTime] [datetime2](7) NULL,
  [ErrorNumber] [int] NULL,
  [ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED
(
  [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommandExecute]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommandExecute] AS'
END
GO
ALTER PROCEDURE [dbo].[CommandExecute]

@DatabaseContext nvarchar(max),
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
@LockMessageSeverity int = 16,
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max),
@Execute nvarchar(max)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorMessageOriginal nvarchar(max)
  DECLARE @Severity int

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @sp_executesql nvarchar(max) = QUOTENAME(@DatabaseContext) + '.sys.sp_executesql'

  DECLARE @StartTime datetime2
  DECLARE @EndTime datetime2

  DECLARE @ID int

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @RevertCommand nvarchar(max)

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseContext IS NULL OR NOT EXISTS (SELECT * FROM sys.databases WHERE name = @DatabaseContext)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseContext is not supported.', 16, 1
  END

  IF @Command IS NULL OR @Command = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Command is not supported.', 16, 1
  END

  IF @CommandType IS NULL OR @CommandType = '' OR LEN(@CommandType) > 60
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CommandType is not supported.', 16, 1
  END

  IF @Mode NOT IN(1,2) OR @Mode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Mode is not supported.', 16, 1
  END

  IF @LockMessageSeverity NOT IN(10,16) OR @LockMessageSeverity IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute as user                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @ExecuteAsUser IS NOT NULL
  BEGIN
    SET @Command = 'EXECUTE AS USER = ''' + REPLACE(@ExecuteAsUser,'''','''''') + '''; ' + @Command + '; REVERT;'

    SET @RevertCommand = 'REVERT'
  END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = SYSDATETIME()

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Database context: ' + QUOTENAME(@DatabaseContext)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Command: ' + @Command
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  IF @Comment IS NOT NULL
  BEGIN
    SET @StartMessage = 'Comment: ' + @Comment
    RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT
  END

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
    EXECUTE @sp_executesql @stmt = @Command
    SET @Error = @@ERROR
    SET @ReturnCode = @Error
  END

  IF @Mode = 2 AND @Execute = 'Y'
  BEGIN
    BEGIN TRY
      EXECUTE @sp_executesql @stmt = @Command
    END TRY
    BEGIN CATCH
      SET @Error = ERROR_NUMBER()
      SET @ErrorMessageOriginal = ERROR_MESSAGE()

      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
      RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT

      IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
      BEGIN
        SET @ReturnCode = ERROR_NUMBER()
      END

      IF @ExecuteAsUser IS NOT NULL
      BEGIN
        EXECUTE @sp_executesql @RevertCommand
      END
    END CATCH
  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  SET @EndTime = SYSDATETIME()

  SET @EndMessage = 'Outcome: ' + CASE WHEN @Execute = 'N' THEN 'Not Executed' WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Duration: ' + CASE WHEN (DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) > 0 THEN CAST((DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) AS nvarchar) + '.' ELSE '' END + CONVERT(nvarchar,DATEADD(SECOND,DATEDIFF(SECOND,@StartTime,@EndTime),'1900-01-01'),108)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,@EndTime,120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseBackup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DatabaseBackup] AS'
END
GO
ALTER PROCEDURE [dbo].[DatabaseBackup]

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
@MinBackupSizeForMultipleFiles int = NULL,
@MaxFileSize int = NULL,
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
@MirrorURL nvarchar(max) = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@Updateability nvarchar(max) = 'ALL',
@AdaptiveCompression nvarchar(max) = NULL,
@ModificationLevel int = NULL,
@LogSizeSinceLastLogBackup int = NULL,
@TimeSinceLastLogBackup int = NULL,
@DataDomainBoostHost nvarchar(max) = NULL,
@DataDomainBoostUser nvarchar(max) = NULL,
@DataDomainBoostDevicePath nvarchar(max) = NULL,
@DataDomainBoostLockboxPath nvarchar(max) = NULL,
@DirectoryStructure nvarchar(max) = '{ServerName}${InstanceName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@AvailabilityGroupDirectoryStructure nvarchar(max) = '{ClusterName}${AvailabilityGroupName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@FileName nvarchar(max) = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@AvailabilityGroupFileName nvarchar(max) = '{ClusterName}${AvailabilityGroupName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@FileExtensionFull nvarchar(max) = NULL,
@FileExtensionDiff nvarchar(max) = NULL,
@FileExtensionLog nvarchar(max) = NULL,
@Init nvarchar(max) = 'N',
@Format nvarchar(max) = 'N',
@ObjectLevelRecoveryMap nvarchar(max) = 'N',
@ExcludeLogShippedFromLogBackup nvarchar(max) = 'Y',
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)
  DECLARE @DirectorySeparator nvarchar(max)

  DECLARE @Updated bit

  DECLARE @Cluster nvarchar(max)

  DECLARE @DefaultDirectory nvarchar(4000)

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentRootDirectoryID int
  DECLARE @CurrentRootDirectoryPath nvarchar(4000)

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)
  DECLARE @CurrentDatabaseSize bigint

  DECLARE @CurrentIsEncrypted bit

  DECLARE @CurrentBackupType nvarchar(max)
  DECLARE @CurrentMaxTransferSize int
  DECLARE @CurrentNumberOfFiles int
  DECLARE @CurrentFileExtension nvarchar(max)
  DECLARE @CurrentFileNumber int
  DECLARE @CurrentDifferentialBaseLSN numeric(25,0)
  DECLARE @CurrentDifferentialBaseIsSnapshot bit
  DECLARE @CurrentLogLSN numeric(25,0)
  DECLARE @CurrentLatestBackup datetime2
  DECLARE @CurrentDatabaseNameFS nvarchar(max)
  DECLARE @CurrentDirectoryStructure nvarchar(max)
  DECLARE @CurrentDatabaseFileName nvarchar(max)
  DECLARE @CurrentMaxFilePathLength nvarchar(max)
  DECLARE @CurrentFileName nvarchar(max)
  DECLARE @CurrentDirectoryID int
  DECLARE @CurrentDirectoryPath nvarchar(max)
  DECLARE @CurrentFilePath nvarchar(max)
  DECLARE @CurrentDate datetime2
  DECLARE @CurrentCleanupDate datetime2
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentAvailabilityGroupBackupPreference nvarchar(max)
  DECLARE @CurrentIsPreferredBackupReplica bit
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)
  DECLARE @CurrentLogShippingRole nvarchar(max)

  DECLARE @CurrentBackupSetID int
  DECLARE @CurrentIsMirror bit
  DECLARE @CurrentLastLogBackup datetime2
  DECLARE @CurrentLogSizeSinceLastLogBackup float
  DECLARE @CurrentAllocatedExtentPageCount bigint
  DECLARE @CurrentModifiedExtentPageCount bigint

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @Directories TABLE (ID int PRIMARY KEY,
                              DirectoryPath nvarchar(max),
                              Mirror bit,
                              Completed bit)

  DECLARE @URLs TABLE (ID int PRIMARY KEY,
                       DirectoryPath nvarchar(max),
                       Mirror bit)

  DECLARE @DirectoryInfo TABLE (FileExists bit,
                                FileIsADirectory bit,
                                ParentDirectoryExists bit)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseNameFS nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               StartPosition int,
                               DatabaseSize bigint,
                               LogSizeSinceLastLogBackup float,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @CurrentBackupOutput bit

  DECLARE @CurrentBackupSet TABLE (ID int IDENTITY PRIMARY KEY,
                                   Mirror bit,
                                   VerifyCompleted bit,
                                   VerifyOutput int)

  DECLARE @CurrentDirectories TABLE (ID int PRIMARY KEY,
                                     DirectoryPath nvarchar(max),
                                     Mirror bit,
                                     DirectoryNumber int,
                                     CleanupDate datetime2,
                                     CleanupMode nvarchar(max),
                                     CreateCompleted bit,
                                     CleanupCompleted bit,
                                     CreateOutput int,
                                     CleanupOutput int)

  DECLARE @CurrentURLs TABLE (ID int PRIMARY KEY,
                              DirectoryPath nvarchar(max),
                              Mirror bit,
                              DirectoryNumber int)

  DECLARE @CurrentFiles TABLE ([Type] nvarchar(max),
                               FilePath nvarchar(max),
                               Mirror bit)

  DECLARE @CurrentCleanupDates TABLE (CleanupDate datetime2,
                                      Mirror bit)

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @Directory = ' + ISNULL('''' + REPLACE(@Directory,'''','''''') + '''','NULL')
  SET @Parameters += ', @BackupType = ' + ISNULL('''' + REPLACE(@BackupType,'''','''''') + '''','NULL')
  SET @Parameters += ', @Verify = ' + ISNULL('''' + REPLACE(@Verify,'''','''''') + '''','NULL')
  SET @Parameters += ', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL')
  SET @Parameters += ', @CleanupMode = ' + ISNULL('''' + REPLACE(@CleanupMode,'''','''''') + '''','NULL')
  SET @Parameters += ', @Compress = ' + ISNULL('''' + REPLACE(@Compress,'''','''''') + '''','NULL')
  SET @Parameters += ', @CopyOnly = ' + ISNULL('''' + REPLACE(@CopyOnly,'''','''''') + '''','NULL')
  SET @Parameters += ', @ChangeBackupType = ' + ISNULL('''' + REPLACE(@ChangeBackupType,'''','''''') + '''','NULL')
  SET @Parameters += ', @BackupSoftware = ' + ISNULL('''' + REPLACE(@BackupSoftware,'''','''''') + '''','NULL')
  SET @Parameters += ', @CheckSum = ' + ISNULL('''' + REPLACE(@CheckSum,'''','''''') + '''','NULL')
  SET @Parameters += ', @BlockSize = ' + ISNULL(CAST(@BlockSize AS nvarchar),'NULL')
  SET @Parameters += ', @BufferCount = ' + ISNULL(CAST(@BufferCount AS nvarchar),'NULL')
  SET @Parameters += ', @MaxTransferSize = ' + ISNULL(CAST(@MaxTransferSize AS nvarchar),'NULL')
  SET @Parameters += ', @NumberOfFiles = ' + ISNULL(CAST(@NumberOfFiles AS nvarchar),'NULL')
  SET @Parameters += ', @MinBackupSizeForMultipleFiles = ' + ISNULL(CAST(@MinBackupSizeForMultipleFiles AS nvarchar),'NULL')
  SET @Parameters += ', @MaxFileSize = ' + ISNULL(CAST(@MaxFileSize AS nvarchar),'NULL')
  SET @Parameters += ', @CompressionLevel = ' + ISNULL(CAST(@CompressionLevel AS nvarchar),'NULL')
  SET @Parameters += ', @Description = ' + ISNULL('''' + REPLACE(@Description,'''','''''') + '''','NULL')
  SET @Parameters += ', @Threads = ' + ISNULL(CAST(@Threads AS nvarchar),'NULL')
  SET @Parameters += ', @Throttle = ' + ISNULL(CAST(@Throttle AS nvarchar),'NULL')
  SET @Parameters += ', @Encrypt = ' + ISNULL('''' + REPLACE(@Encrypt,'''','''''') + '''','NULL')
  SET @Parameters += ', @EncryptionAlgorithm = ' + ISNULL('''' + REPLACE(@EncryptionAlgorithm,'''','''''') + '''','NULL')
  SET @Parameters += ', @ServerCertificate = ' + ISNULL('''' + REPLACE(@ServerCertificate,'''','''''') + '''','NULL')
  SET @Parameters += ', @ServerAsymmetricKey = ' + ISNULL('''' + REPLACE(@ServerAsymmetricKey,'''','''''') + '''','NULL')
  SET @Parameters += ', @EncryptionKey = ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL')
  SET @Parameters += ', @ReadWriteFileGroups = ' + ISNULL('''' + REPLACE(@ReadWriteFileGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @OverrideBackupPreference = ' + ISNULL('''' + REPLACE(@OverrideBackupPreference,'''','''''') + '''','NULL')
  SET @Parameters += ', @NoRecovery = ' + ISNULL('''' + REPLACE(@NoRecovery,'''','''''') + '''','NULL')
  SET @Parameters += ', @URL = ' + ISNULL('''' + REPLACE(@URL,'''','''''') + '''','NULL')
  SET @Parameters += ', @Credential = ' + ISNULL('''' + REPLACE(@Credential,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorDirectory = ' + ISNULL('''' + REPLACE(@MirrorDirectory,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorCleanupTime = ' + ISNULL(CAST(@MirrorCleanupTime AS nvarchar),'NULL')
  SET @Parameters += ', @MirrorCleanupMode = ' + ISNULL('''' + REPLACE(@MirrorCleanupMode,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorURL = ' + ISNULL('''' + REPLACE(@MirrorURL,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @Parameters += ', @AdaptiveCompression = ' + ISNULL('''' + REPLACE(@AdaptiveCompression,'''','''''') + '''','NULL')
  SET @Parameters += ', @ModificationLevel = ' + ISNULL(CAST(@ModificationLevel AS nvarchar),'NULL')
  SET @Parameters += ', @LogSizeSinceLastLogBackup = ' + ISNULL(CAST(@LogSizeSinceLastLogBackup AS nvarchar),'NULL')
  SET @Parameters += ', @TimeSinceLastLogBackup = ' + ISNULL(CAST(@TimeSinceLastLogBackup AS nvarchar),'NULL')
  SET @Parameters += ', @DataDomainBoostHost = ' + ISNULL('''' + REPLACE(@DataDomainBoostHost,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostUser = ' + ISNULL('''' + REPLACE(@DataDomainBoostUser,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostDevicePath = ' + ISNULL('''' + REPLACE(@DataDomainBoostDevicePath,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostLockboxPath = ' + ISNULL('''' + REPLACE(@DataDomainBoostLockboxPath,'''','''''') + '''','NULL')
  SET @Parameters += ', @DirectoryStructure = ' + ISNULL('''' + REPLACE(@DirectoryStructure,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupDirectoryStructure = ' + ISNULL('''' + REPLACE(@AvailabilityGroupDirectoryStructure,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileName = ' + ISNULL('''' + REPLACE(@FileName,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupFileName = ' + ISNULL('''' + REPLACE(@AvailabilityGroupFileName,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionFull = ' + ISNULL('''' + REPLACE(@FileExtensionFull,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionDiff = ' + ISNULL('''' + REPLACE(@FileExtensionDiff,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionLog = ' + ISNULL('''' + REPLACE(@FileExtensionLog,'''','''''') + '''','NULL')
  SET @Parameters += ', @Init = ' + ISNULL('''' + REPLACE(@Init,'''','''''') + '''','NULL')
  SET @Parameters += ', @Format = ' + ISNULL('''' + REPLACE(@Format,'''','''''') + '''','NULL')
  SET @Parameters += ', @ObjectLevelRecoveryMap = ' + ISNULL('''' + REPLACE(@ObjectLevelRecoveryMap,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExcludeLogShippedFromLogBackup = ' + ISNULL('''' + REPLACE(@ExcludeLogShippedFromLogBackup,'''','''''') + '''','NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  IF @AmazonRDS = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure DatabaseBackup is not supported on Amazon RDS.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseNameFS, DatabaseType, AvailabilityGroup, [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([name],'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|','')) AS DatabaseNameFS,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

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

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

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

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
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
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The names of the following databases are not supported: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 16, 1
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
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The names of the following databases are not unique in the file system: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select default directory                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Directory IS NULL AND @URL IS NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    IF @Version >= 15
    BEGIN
      SET @DefaultDirectory = CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS nvarchar(max))
    END
    ELSE
    BEGIN
      EXECUTE [master].dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @DefaultDirectory OUTPUT
    END

    IF @DefaultDirectory LIKE 'http://%' OR @DefaultDirectory LIKE 'https://%'
    BEGIN
      SET @URL = @DefaultDirectory
    END
    ELSE
    BEGIN
      INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
      SELECT 1, @DefaultDirectory, 0, 0
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Select directories                                                                         //--
  ----------------------------------------------------------------------------------------------------

  SET @Directory = REPLACE(@Directory, CHAR(10), '')
  SET @Directory = REPLACE(@Directory, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Directory) > 0 SET @Directory = REPLACE(@Directory, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Directory) > 0 SET @Directory = REPLACE(@Directory, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Directory = LTRIM(RTRIM(@Directory));

  WITH Directories (StartPosition, EndPosition, Directory) AS
  (
  SELECT 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, 1), 0), LEN(@Directory) + 1) AS EndPosition,
          SUBSTRING(@Directory, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, 1), 0), LEN(@Directory) + 1) - 1) AS Directory
  WHERE @Directory IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) AS EndPosition,
          SUBSTRING(@Directory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) - EndPosition - 1) AS Directory
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

  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(10), '')
  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(13), '')

  WHILE CHARINDEX(', ',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,', ',',')
  WHILE CHARINDEX(' ,',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,' ,',',')

  SET @MirrorDirectory = LTRIM(RTRIM(@MirrorDirectory));

  WITH Directories (StartPosition, EndPosition, Directory) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) - 1) AS Directory
  WHERE @MirrorDirectory IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) - EndPosition - 1) AS Directory
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

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%' OR (DirectoryPath LIKE '/%/%' AND @HostPlatform = 'Linux') OR DirectoryPath = 'NUL') OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' '))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 3
  END

  IF (@Directory IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 8) OR (@Directory IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 4
  END

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath = 'NUL') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath <> 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 5
  END

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath = 'NUL') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Directories WHERE Mirror = 1 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%' OR (DirectoryPath LIKE '/%/%' AND @HostPlatform = 'Linux')) OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' '))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 3
  END

  IF @BackupSoftware IN('SQLBACKUP','SQLSAFE') AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 4
  END

  IF @MirrorDirectory IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 8
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 5
  END

  IF @MirrorDirectory IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 6
  END

  IF EXISTS(SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath = 'NUL') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 7
  END

  IF (@BackupSoftware IS NULL AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1) AND SERVERPROPERTY('EngineEdition') <> 3)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported. Mirrored backup to disk is only available in Enterprise and Developer Edition.', 16, 8
  END

  ----------------------------------------------------------------------------------------------------

  IF NOT EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    WHILE (1 = 1)
    BEGIN
      SELECT TOP 1 @CurrentRootDirectoryID = ID,
                   @CurrentRootDirectoryPath = DirectoryPath
      FROM @Directories
      WHERE Completed = 0
      AND DirectoryPath <> 'NUL'
      ORDER BY ID ASC

      IF @@ROWCOUNT = 0
      BEGIN
        BREAK
      END

      INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
      EXECUTE [master].dbo.xp_fileexist @CurrentRootDirectoryPath

      IF NOT EXISTS (SELECT * FROM @DirectoryInfo WHERE FileExists = 0 AND FileIsADirectory = 1 AND ParentDirectoryExists = 1)
      BEGIN
        INSERT INTO @Errors ([Message], Severity, [State])
        SELECT 'The directory ' + @CurrentRootDirectoryPath + ' does not exist.', 16, 1
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
  --// Select URLs                                                                                //--
  ----------------------------------------------------------------------------------------------------

  SET @URL = REPLACE(@URL, CHAR(10), '')
  SET @URL = REPLACE(@URL, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @URL) > 0 SET @URL = REPLACE(@URL, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @URL) > 0 SET @URL = REPLACE(@URL, ' ' + @StringDelimiter, @StringDelimiter)

  SET @URL = LTRIM(RTRIM(@URL));

  WITH URLs (StartPosition, EndPosition, [URL]) AS
  (
  SELECT 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, 1), 0), LEN(@URL) + 1) AS EndPosition,
          SUBSTRING(@URL, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, 1), 0), LEN(@URL) + 1) - 1) AS [URL]
  WHERE @URL IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, EndPosition + 1), 0), LEN(@URL) + 1) AS EndPosition,
          SUBSTRING(@URL, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, EndPosition + 1), 0), LEN(@URL) + 1) - EndPosition - 1) AS [URL]
  FROM URLs
  WHERE EndPosition < LEN(@URL) + 1
  )
  INSERT INTO @URLs (ID, DirectoryPath, Mirror)
  SELECT ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
          [URL],
          0
  FROM URLs
  OPTION (MAXRECURSION 0)

  SET @MirrorURL = REPLACE(@MirrorURL, CHAR(10), '')
  SET @MirrorURL = REPLACE(@MirrorURL, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @MirrorURL) > 0 SET @MirrorURL = REPLACE(@MirrorURL, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter ,@MirrorURL) > 0 SET @MirrorURL = REPLACE(@MirrorURL, ' ' + @StringDelimiter, @StringDelimiter)

  SET @MirrorURL = LTRIM(RTRIM(@MirrorURL));

  WITH URLs (StartPosition, EndPosition, [URL]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, 1), 0), LEN(@MirrorURL) + 1) AS EndPosition,
         SUBSTRING(@MirrorURL, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, 1), 0), LEN(@MirrorURL) + 1) - 1) AS [URL]
  WHERE @MirrorURL IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, EndPosition + 1), 0), LEN(@MirrorURL) + 1) AS EndPosition,
         SUBSTRING(@MirrorURL, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, EndPosition + 1), 0), LEN(@MirrorURL) + 1) - EndPosition - 1) AS [URL]
  FROM URLs
  WHERE EndPosition < LEN(@MirrorURL) + 1
  )
  INSERT INTO @URLs (ID, DirectoryPath, Mirror)
  SELECT (SELECT COUNT(*) FROM @URLs) + ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
         [URL],
         1
  FROM URLs
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check URLs                                                                          //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @URLs WHERE Mirror = 0 AND DirectoryPath NOT LIKE 'https://%/%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @URLs GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @URLs WHERE Mirror = 1 AND DirectoryPath NOT LIKE 'https://%/%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @URLs GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Get directory separator                                                                   //--
  ----------------------------------------------------------------------------------------------------

  SELECT @DirectorySeparator = CASE
  WHEN @URL IS NOT NULL THEN '/'
  WHEN @HostPlatform = 'Windows' THEN '\'
  WHEN @HostPlatform = 'Linux' THEN '/'
  END

  UPDATE @Directories
  SET DirectoryPath = LEFT(DirectoryPath,LEN(DirectoryPath) - 1)
  WHERE RIGHT(DirectoryPath,1) = @DirectorySeparator

  UPDATE @URLs
  SET DirectoryPath = LEFT(DirectoryPath,LEN(DirectoryPath) - 1)
  WHERE RIGHT(DirectoryPath,1) = @DirectorySeparator

  ----------------------------------------------------------------------------------------------------
  --// Get file extension                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionFull IS NULL
  BEGIN
    SELECT @FileExtensionFull = CASE
    WHEN @BackupSoftware IS NULL THEN 'bak'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'bak'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  IF @FileExtensionDiff IS NULL
  BEGIN
    SELECT @FileExtensionDiff = CASE
    WHEN @BackupSoftware IS NULL THEN 'bak'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'bak'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  IF @FileExtensionLog IS NULL
  BEGIN
    SELECT @FileExtensionLog = CASE
    WHEN @BackupSoftware IS NULL THEN 'trn'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'trn'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Get default compression                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF @Compress IS NULL
  BEGIN
    SELECT @Compress = CASE WHEN @BackupSoftware IS NULL AND EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'Y'
                            WHEN @BackupSoftware IS NULL AND NOT EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'N'
                            WHEN @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel > 0)  THEN 'Y'
                            WHEN @BackupSoftware IS NOT NULL AND @CompressionLevel = 0  THEN 'N' END
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @BackupType NOT IN ('FULL','DIFF','LOG') OR @BackupType IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupType is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 8 AND NOT (@BackupType = 'FULL' AND @CopyOnly = 'Y')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'SQL Database Managed Instance only supports COPY_ONLY full backups.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Verify NOT IN ('Y','N') OR @Verify IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported.', 16, 1
  END

  IF @BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND @Verify = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported with encrypted backups with Idera SQL Safe Backup', 16, 2
  END

  IF @Verify = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported with Data Domain Boost', 16, 3
  END

  IF @Verify = 'Y' AND EXISTS(SELECT * FROM @Directories WHERE DirectoryPath = 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported when backing up to NUL.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @CleanupTime < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported.', 16, 1
  END

  IF @CleanupTime IS NOT NULL AND @URL IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported on Azure Blob Storage.', 16, 2
  END

  IF @CleanupTime IS NOT NULL AND EXISTS(SELECT * FROM @Directories WHERE DirectoryPath = 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported when backing up to NUL.', 16, 4
  END

  IF @CleanupTime IS NOT NULL AND ((@DirectoryStructure NOT LIKE '%{DatabaseName}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{DatabaseName}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {DatabaseName} is not part of the directory.', 16, 5
  END

  IF @CleanupTime IS NOT NULL AND ((@DirectoryStructure NOT LIKE '%{BackupType}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{BackupType}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {BackupType} is not part of the directory.', 16, 6
  END

  IF @CleanupTime IS NOT NULL AND @CopyOnly = 'Y' AND ((@DirectoryStructure NOT LIKE '%{CopyOnly}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{CopyOnly}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {CopyOnly} is not part of the directory.', 16, 7
  END

  ----------------------------------------------------------------------------------------------------

  IF @CleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @CleanupMode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupMode is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Compress NOT IN ('Y','N') OR @Compress IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 1
  END

  IF @Compress = 'Y' AND @BackupSoftware IS NULL AND NOT ((@Version >= 10 AND @Version < 10.5 AND SERVERPROPERTY('EngineEdition') = 3) OR (@Version >= 10.5 AND (SERVERPROPERTY('EngineEdition') IN (3, 8) OR SERVERPROPERTY('EditionID') IN (-1534726760, 284895786))))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 2
  END

  IF @Compress = 'N' AND @BackupSoftware IN ('LITESPEED','SQLBACKUP','SQLSAFE') AND (@CompressionLevel IS NULL OR @CompressionLevel >= 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 3
  END

  IF @Compress = 'Y' AND @BackupSoftware IN ('LITESPEED','SQLBACKUP','SQLSAFE') AND @CompressionLevel = 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @CopyOnly NOT IN ('Y','N') OR @CopyOnly IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CopyOnly is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @ChangeBackupType NOT IN ('Y','N') OR @ChangeBackupType IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ChangeBackupType is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @BackupSoftware NOT IN ('LITESPEED','SQLBACKUP','SQLSAFE','DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupSoftware is not supported.', 16, 1
  END

  IF @BackupSoftware IS NOT NULL AND @HostPlatform = 'Linux'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupSoftware is not supported. Only native backups are supported on Linux', 16, 2
  END

  IF @BackupSoftware = 'LITESPEED' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_backup_database')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'LiteSpeed for SQL Server is not installed. Download https://www.quest.com/products/litespeed-for-sql-server/.', 16, 3
  END

  IF @BackupSoftware = 'SQLBACKUP' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'sqlbackup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Red Gate SQL Backup Pro is not installed. Download https://www.red-gate.com/products/dba/sql-backup/.', 16, 4
  END

  IF @BackupSoftware = 'SQLSAFE' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_ss_backup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Idera SQL Safe Backup is not installed. Download https://www.idera.com/productssolutions/sqlserver/sqlsafebackup.', 16, 5
  END

  IF @BackupSoftware = 'DATA_DOMAIN_BOOST' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'PC' AND [name] = 'emc_run_backup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'EMC Data Domain Boost is not installed. Download https://www.emc.com/en-us/data-protection/data-domain.htm.', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF @CheckSum NOT IN ('Y','N') OR @CheckSum IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckSum is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @BlockSize NOT IN (512,1024,2048,4096,8192,16384,32768,65536)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported.', 16, 1
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Redgate SQL Backup Pro', 16, 2
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Idera SQL Safe', 16, 3
  END

  IF @BlockSize IS NOT NULL AND @URL IS NOT NULL AND @Credential IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported.', 16, 4
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Data Domain Boost', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @BufferCount <= 0 OR @BufferCount > 2147483647
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 1
  END

  IF @BufferCount IS NOT NULL AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 2
  END

  IF @BufferCount IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxTransferSize < 65536 OR @MaxTransferSize > 4194304
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 1
  END

  IF @MaxTransferSize > 1048576 AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 2
  END

  IF @MaxTransferSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 3
  END

  IF @MaxTransferSize IS NOT NULL AND @URL IS NOT NULL AND @Credential IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 4
  END

  IF @MaxTransferSize IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @NumberOfFiles < 1 OR @NumberOfFiles > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 1
  END

  IF @NumberOfFiles > 32 AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 2
  END

  IF @NumberOfFiles < (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 3
  END

  IF @NumberOfFiles % (SELECT NULLIF(COUNT(*),0) FROM @Directories WHERE Mirror = 0) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 4
  END

  IF @URL IS NOT NULL AND @Credential IS NOT NULL AND @NumberOfFiles <> 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 5
  END

  IF @NumberOfFiles > 1 AND @BackupSoftware IN('SQLBACKUP','SQLSAFE') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 6
  END

  IF @NumberOfFiles > 32 AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 7
  END

  IF @NumberOfFiles < (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 8
  END

  IF @NumberOfFiles % (SELECT NULLIF(COUNT(*),0) FROM @URLs WHERE Mirror = 0) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 9
  END

    ----------------------------------------------------------------------------------------------------

  IF @MinBackupSizeForMultipleFiles <= 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported.', 16, 1
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @NumberOfFiles IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. This parameter can only be used together with @NumberOfFiles.', 16, 2
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @BackupType = 'DIFF' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. The column sys.dm_db_file_space_usage.modified_extent_page_count is not available in this version of SQL Server.', 16, 3
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @BackupType = 'LOG' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxFileSize <= 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported.', 16, 1
  END

  IF @MaxFileSize IS NOT NULL AND @NumberOfFiles IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @MaxFileSize and @NumberOfFiles cannot be used together.', 16, 2
  END

  IF @MaxFileSize IS NOT NULL AND @BackupType = 'DIFF' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported. The column sys.dm_db_file_space_usage.modified_extent_page_count is not available in this version of SQL Server.', 16, 3
  END

  IF @MaxFileSize IS NOT NULL AND @BackupType = 'LOG' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF (@BackupSoftware IS NULL AND @CompressionLevel IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND (@CompressionLevel < 0  OR @CompressionLevel > 8)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND (@CompressionLevel < 0 OR @CompressionLevel > 4)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND (@CompressionLevel < 1 OR @CompressionLevel > 4)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 4
  END

  IF @CompressionLevel IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF LEN(@Description) > 255
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND LEN(@Description) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 2
  END

  IF @BackupSoftware = 'DATA_DOMAIN_BOOST' AND LEN(@Description) > 254
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @Threads IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED','SQLBACKUP','SQLSAFE') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND (@Threads < 1 OR @Threads > 32)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND (@Threads < 2 OR @Threads > 32)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND (@Threads < 1 OR @Threads > 64)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @Throttle < 1 OR @Throttle > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Throttle is not supported.', 16, 1
  END

  IF @Throttle IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Throttle is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @Encrypt NOT IN('Y','N') OR @Encrypt IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 1
  END

  IF @Encrypt = 'Y' AND @BackupSoftware IS NULL AND NOT (@Version >= 12 AND (SERVERPROPERTY('EngineEdition') = 3) OR SERVERPROPERTY('EditionID') IN(-1534726760, 284895786))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 2
  END

  IF @Encrypt = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_192','AES_256','TRIPLE_DES_3KEY') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('RC2_40','RC2_56','RC2_112','RC2_128','TRIPLE_DES_3KEY','RC4_128','AES_128','AES_192','AES_256') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL)
  OR (@EncryptionAlgorithm IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 4
  END

  IF @EncryptionAlgorithm IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF (NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerCertificate IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 1
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NULL AND @ServerAsymmetricKey IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 2
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL AND @ServerAsymmetricKey IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 3
  END

  IF @ServerCertificate IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.certificates WHERE name = @ServerCertificate)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerAsymmetricKey IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 1
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NULL AND @ServerCertificate IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 2
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL AND @ServerCertificate IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 3
  END

  IF @ServerAsymmetricKey IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.asymmetric_keys WHERE name = @ServerAsymmetricKey)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @EncryptionKey IS NOT NULL AND @BackupSoftware IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 1
  END

  IF @EncryptionKey IS NOT NULL AND @Encrypt = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 2
  END

  IF @EncryptionKey IS NULL AND @Encrypt = 'Y' AND @BackupSoftware IN('LITESPEED','SQLBACKUP','SQLSAFE')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 3
  END

  IF @EncryptionKey IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @ReadWriteFileGroups NOT IN('Y','N') OR @ReadWriteFileGroups IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ReadWriteFileGroups is not supported.', 16, 1
  END

  IF @ReadWriteFileGroups = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ReadWriteFileGroups is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @OverrideBackupPreference NOT IN('Y','N') OR @OverrideBackupPreference IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @OverrideBackupPreference is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @NoRecovery NOT IN('Y','N') OR @NoRecovery IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 1
  END

  IF @NoRecovery = 'Y' AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 2
  END

  IF @NoRecovery = 'Y' AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @URL IS NOT NULL AND @Directory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 1
  END

  IF @URL IS NOT NULL AND @MirrorDirectory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 2
  END

  IF @URL IS NOT NULL AND @Version < 11.03339
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 3
  END

  IF @URL IS NOT NULL AND @BackupSoftware IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @Credential IS NULL AND @URL IS NOT NULL AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') = 8)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 1
  END

  IF @Credential IS NOT NULL AND @URL IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 2
  END

  IF @URL IS NOT NULL AND @Credential IS NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE UPPER(credential_identity) = 'SHARED ACCESS SIGNATURE')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 3
  END

  IF @Credential IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE name = @Credential)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorCleanupTime < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupTime is not supported.', 16, 1
  END

  IF @MirrorCleanupTime IS NOT NULL AND @MirrorDirectory IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupTime is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorCleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @MirrorCleanupMode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupMode is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorURL IS NOT NULL AND @Directory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 1
  END

  IF @MirrorURL IS NOT NULL AND @MirrorDirectory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 2
  END

  IF @MirrorURL IS NOT NULL AND @Version < 11.03339
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 3
  END

  IF @MirrorURL IS NOT NULL AND @BackupSoftware IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 4
  END

  IF @MirrorURL IS NOT NULL AND @URL IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Updateability is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @AdaptiveCompression NOT IN('SIZE','SPEED')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AdaptiveCompression is not supported.', 16, 1
  END

  IF @AdaptiveCompression IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AdaptiveCompression is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @ModificationLevel IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ModificationLevel is not supported.', 16, 1
  END

  IF @ModificationLevel IS NOT NULL AND @ChangeBackupType = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ModificationLevel is not supported.', 16, 2
  END

  IF @ModificationLevel IS NOT NULL AND @BackupType <> 'DIFF'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ModificationLevel is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogSizeSinceLastLogBackup IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogSizeSinceLastLogBackup is not supported.', 16, 1
  END

  IF @LogSizeSinceLastLogBackup IS NOT NULL AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogSizeSinceLastLogBackup is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeSinceLastLogBackup IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_backup_time')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeSinceLastLogBackup is not supported.', 16, 1
  END

  IF @TimeSinceLastLogBackup IS NOT NULL AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeSinceLastLogBackup is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF (@TimeSinceLastLogBackup IS NOT NULL AND @LogSizeSinceLastLogBackup IS NULL) OR (@TimeSinceLastLogBackup IS NULL AND @LogSizeSinceLastLogBackup IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @TimeSinceLastLogBackup and @LogSizeSinceLastLogBackup can only be used together.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostHost IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostHost is not supported.', 16, 1
  END

  IF @DataDomainBoostHost IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostHost is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostUser IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostUser is not supported.', 16, 1
  END

  IF @DataDomainBoostUser IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostUser is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostDevicePath IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostDevicePath is not supported.', 16, 1
  END

  IF @DataDomainBoostDevicePath IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostDevicePath is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostLockboxPath IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostLockboxPath is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DirectoryStructure = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DirectoryStructure is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroupDirectoryStructure = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupDirectoryStructure is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileName IS NULL OR @FileName = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 1
  END

  IF @FileName NOT LIKE '%.{FileExtension}'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 2
  END

  IF (@NumberOfFiles > 1 AND @FileName NOT LIKE '%{FileNumber}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 3
  END

  IF @FileName LIKE '%{DirectorySeparator}%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 4
  END

  IF @FileName LIKE '%/%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 5
  END

  IF @FileName LIKE '%\%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF (SERVERPROPERTY('IsHadrEnabled') = 1 AND @AvailabilityGroupFileName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 1
  END

  IF @AvailabilityGroupFileName = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 2
  END

  IF @AvailabilityGroupFileName NOT LIKE '%.{FileExtension}'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 3
  END

  IF (@NumberOfFiles > 1 AND @AvailabilityGroupFileName NOT LIKE '%{FileNumber}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 4
  END

  IF @AvailabilityGroupFileName LIKE '%{DirectorySeparator}%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 5
  END

  IF @AvailabilityGroupFileName LIKE '%/%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 6
  END

  IF @AvailabilityGroupFileName LIKE '%\%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 7
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DirectoryStructure,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{MajorVersion}',''),'{MinorVersion}','') AS DirectoryStructure) Temp WHERE DirectoryStructure LIKE '%{%' OR DirectoryStructure LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @DirectoryStructure contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@AvailabilityGroupDirectoryStructure,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{MajorVersion}',''),'{MinorVersion}','') AS AvailabilityGroupDirectoryStructure) Temp WHERE AvailabilityGroupDirectoryStructure LIKE '%{%' OR AvailabilityGroupDirectoryStructure LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @AvailabilityGroupDirectoryStructure contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@FileName,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{FileNumber}',''),'{NumberOfFiles}',''),'{FileExtension}',''),'{MajorVersion}',''),'{MinorVersion}','') AS [FileName]) Temp WHERE [FileName] LIKE '%{%' OR [FileName] LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @FileName contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@AvailabilityGroupFileName,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{FileNumber}',''),'{NumberOfFiles}',''),'{FileExtension}',''),'{MajorVersion}',''),'{MinorVersion}','') AS AvailabilityGroupFileName) Temp WHERE AvailabilityGroupFileName LIKE '%{%' OR AvailabilityGroupFileName LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @AvailabilityGroupFileName contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionFull LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionFull is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionDiff LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionDiff is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionLog LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionLog is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Init NOT IN('Y','N') OR @Init IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 1
  END

  IF @Init = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 2
  END

  IF @Init = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @Format NOT IN('Y','N') OR @Format IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 1
  END

  IF @Format = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 2
  END

  IF @Format = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @ObjectLevelRecoveryMap NOT IN('Y','N') OR @ObjectLevelRecoveryMap IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 1
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupSoftware IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 2
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupSoftware <> 'LITESPEED'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 3
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @ExcludeLogShippedFromLogBackup NOT IN('Y','N') OR @ExcludeLogShippedFromLogBackup IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExcludeLogShippedFromLogBackup is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IN('LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC') AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 2
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-backup.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check @@SERVERNAME                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @@SERVERNAME <> CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The @@SERVERNAME does not match SERVERPROPERTY(''ServerName''). See ' + CASE WHEN SERVERPROPERTY('IsClustered') = 0 THEN 'https://docs.microsoft.com/en-us/sql/database-engine/install-windows/rename-a-computer-that-hosts-a-stand-alone-instance-of-sql-server' WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'https://docs.microsoft.com/en-us/sql/sql-server/failover-clusters/install/rename-a-sql-server-failover-cluster-instance' END + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Check Availability Group cluster name                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    SELECT @Cluster = NULLIF(cluster_name,'')
    FROM sys.dm_hadr_cluster
  END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LogSizeSinceLastLogBackup = (SELECT log_since_last_log_backup_mb FROM sys.dm_db_log_stats(DB_ID(tmpDatabases.DatabaseName)))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LogSizeSinceLastLogBackup ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LogSizeSinceLastLogBackup DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute backup commands                                                                    //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName,
          @CurrentDatabaseNameFS = (SELECT DatabaseNameFS FROM @tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName)
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName,
                   @CurrentDatabaseNameFS = DatabaseNameFS
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
      BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc,
           @CurrentIsEncrypted = is_encrypted,
           @CurrentDatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = sys.databases.database_id)
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage =  'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage =  'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Encrypted: ' + CASE WHEN @CurrentIsEncrypted = 1 THEN 'Yes' WHEN @CurrentIsEncrypted = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentMaxTransferSize = CASE
    WHEN @MaxTransferSize IS NOT NULL THEN @MaxTransferSize
    WHEN @MaxTransferSize IS NULL AND @Compress = 'Y' AND @CurrentIsEncrypted = 1 AND @BackupSoftware IS NULL AND (@Version >= 13 AND @Version < 15.0404316) THEN 65537
    END

    IF @CurrentDatabaseState = 'ONLINE'
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name],
             @CurrentAvailabilityGroupBackupPreference = UPPER(automated_backup_preference_desc)
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1 AND @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SELECT @CurrentIsPreferredBackupReplica = sys.fn_hadr_backup_is_preferred_replica(@CurrentDatabaseName)
    END

    SELECT @CurrentDifferentialBaseLSN = differential_base_lsn
    FROM sys.master_files
    WHERE database_id = DB_ID(@CurrentDatabaseName)
    AND [type] = 0
    AND [file_id] = 1

    IF @CurrentDatabaseState = 'ONLINE'
    BEGIN
      SELECT @CurrentLogLSN = last_log_backup_lsn
      FROM sys.database_recovery_status
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentDatabaseState = 'ONLINE' AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count') AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL)
    BEGIN
      SET @CurrentCommand = 'SELECT @ParamAllocatedExtentPageCount = SUM(allocated_extent_page_count), @ParamModifiedExtentPageCount = SUM(modified_extent_page_count) FROM sys.dm_db_file_space_usage'

      EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamAllocatedExtentPageCount bigint OUTPUT, @ParamModifiedExtentPageCount bigint OUTPUT', @ParamAllocatedExtentPageCount = @CurrentAllocatedExtentPageCount OUTPUT, @ParamModifiedExtentPageCount = @CurrentModifiedExtentPageCount OUTPUT
    END

    SET @CurrentBackupType = @BackupType

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'LOG' AND @CurrentRecoveryModel IN('FULL','BULK_LOGGED') AND @CurrentLogLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'DIFF'
      END
      IF @CurrentBackupType = 'DIFF' AND (@CurrentDatabaseName = 'master' OR @CurrentDifferentialBaseLSN IS NULL OR (@CurrentModifiedExtentPageCount * 1. / @CurrentAllocatedExtentPageCount * 100 >= @ModificationLevel))
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END

    IF @CurrentDatabaseState = 'ONLINE' AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
    BEGIN
      SELECT @CurrentLastLogBackup = log_backup_time,
             @CurrentLogSizeSinceLastLogBackup = log_since_last_log_backup_mb
      FROM sys.dm_db_log_stats (DB_ID(@CurrentDatabaseName))
    END

    IF @CurrentBackupType = 'DIFF'
    BEGIN
      SELECT @CurrentDifferentialBaseIsSnapshot = is_snapshot
      FROM msdb.dbo.backupset
      WHERE database_name = @CurrentDatabaseName
      AND [type] = 'D'
      AND checkpoint_lsn = @CurrentDifferentialBaseLSN
    END

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseIsSnapshot = 1
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END;

    WITH CurrentDatabase AS
    (
    SELECT BackupSize = CASE WHEN @CurrentBackupType = 'FULL' THEN COALESCE(CAST(@CurrentAllocatedExtentPageCount AS bigint) * 8192, CAST(@CurrentDatabaseSize AS bigint) * 8192)
                             WHEN @CurrentBackupType = 'DIFF' THEN CAST(@CurrentModifiedExtentPageCount AS bigint) * 8192
                             WHEN @CurrentBackupType = 'LOG' THEN CAST(@CurrentLogSizeSinceLastLogBackup * 1024 * 1024 AS bigint)
                             END,
           MaxNumberOfFiles = CASE WHEN @BackupSoftware IN('SQLBACKUP','DATA_DOMAIN_BOOST') THEN 32 ELSE 64 END,
           CASE WHEN (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) > 0 THEN (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) ELSE (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) END AS NumberOfDirectories,
           CAST(@MinBackupSizeForMultipleFiles AS bigint) * 1024 * 1024 AS MinBackupSizeForMultipleFiles,
           CAST(@MaxFileSize AS bigint) * 1024 * 1024 AS MaxFileSize
    )
    SELECT @CurrentNumberOfFiles = CASE WHEN @NumberOfFiles IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST' THEN 1
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NULL THEN NumberOfDirectories
                                        WHEN @NumberOfFiles = 1 THEN @NumberOfFiles
                                        WHEN @NumberOfFiles > 1 AND (BackupSize >= MinBackupSizeForMultipleFiles OR MinBackupSizeForMultipleFiles IS NULL OR BackupSize IS NULL) THEN @NumberOfFiles
                                        WHEN @NumberOfFiles > 1 AND (BackupSize < MinBackupSizeForMultipleFiles) THEN NumberOfDirectories
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NOT NULL AND (BackupSize IS NULL OR BackupSize = 0) THEN NumberOfDirectories
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NOT NULL THEN (SELECT MIN(NumberOfFilesInEachDirectory)
                                                                                                       FROM (SELECT ((BackupSize / NumberOfDirectories) / MaxFileSize + CASE WHEN (BackupSize / NumberOfDirectories) % MaxFileSize = 0 THEN 0 ELSE 1 END) AS NumberOfFilesInEachDirectory
                                                                                                             UNION
                                                                                                             SELECT MaxNumberOfFiles / NumberOfDirectories) Files) * NumberOfDirectories
                                        END

    FROM CurrentDatabase

    SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
    FROM sys.database_mirroring
    WHERE database_id = DB_ID(@CurrentDatabaseName)

    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_primary_databases WHERE primary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'PRIMARY'
    END
    ELSE
    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_secondary_databases WHERE secondary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'SECONDARY'
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group backup preference: ' + ISNULL(@CurrentAvailabilityGroupBackupPreference,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Is preferred backup replica: ' + CASE WHEN @CurrentIsPreferredBackupReplica = 1 THEN 'Yes' WHEN @CurrentIsPreferredBackupReplica = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentLogShippingRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Log shipping role: ' + @CurrentLogShippingRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SET @DatabaseMessage = 'Differential base LSN: ' + ISNULL(CAST(@CurrentDifferentialBaseLSN AS nvarchar),'N/A')
    RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

    IF @CurrentBackupType = 'DIFF' OR @CurrentDifferentialBaseIsSnapshot IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Differential base is snapshot: ' + CASE WHEN @CurrentDifferentialBaseIsSnapshot = 1 THEN 'Yes' WHEN @CurrentDifferentialBaseIsSnapshot = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SET @DatabaseMessage = 'Last log backup LSN: ' + ISNULL(CAST(@CurrentLogLSN AS nvarchar),'N/A')
    RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

    IF @CurrentBackupType IN('DIFF','FULL') AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
    BEGIN
      SET @DatabaseMessage = 'Allocated extent page count: ' + ISNULL(CAST(@CurrentAllocatedExtentPageCount AS nvarchar) + ' (' + CAST(@CurrentAllocatedExtentPageCount * 1. * 8 / 1024 AS nvarchar) + ' MB)','N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Modified extent page count: ' + ISNULL(CAST(@CurrentModifiedExtentPageCount AS nvarchar) + ' (' + CAST(@CurrentModifiedExtentPageCount * 1. * 8 / 1024 AS nvarchar) + ' MB)','N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentBackupType = 'LOG' AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
    BEGIN
      SET @DatabaseMessage = 'Last log backup: ' + ISNULL(CONVERT(nvarchar(19),NULLIF(@CurrentLastLogBackup,'1900-01-01'),120),'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Log size since last log backup (MB): ' + ISNULL(CAST(@CurrentLogSizeSinceLastLogBackup AS nvarchar),'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND NOT (@CurrentInStandby = 1)
    AND NOT (@CurrentBackupType = 'LOG' AND @CurrentRecoveryModel = 'SIMPLE')
    AND NOT (@CurrentBackupType = 'LOG' AND @CurrentRecoveryModel IN('FULL','BULK_LOGGED') AND @CurrentLogLSN IS NULL)
    AND NOT (@CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseLSN IS NULL)
    AND NOT (@CurrentBackupType IN('DIFF','LOG') AND @CurrentDatabaseName = 'master')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'N' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'Y' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'DIFF' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'N' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'Y' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT ((@CurrentLogShippingRole = 'PRIMARY' AND @CurrentLogShippingRole IS NOT NULL) AND @CurrentBackupType = 'LOG' AND @ExcludeLogShippedFromLogBackup = 'Y')
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    AND NOT (@CurrentBackupType = 'LOG' AND @LogSizeSinceLastLogBackup IS NOT NULL AND @TimeSinceLastLogBackup IS NOT NULL AND NOT(@CurrentLogSizeSinceLastLogBackup >= @LogSizeSinceLastLogBackup OR @CurrentLogSizeSinceLastLogBackup IS NULL OR DATEDIFF(SECOND,@CurrentLastLogBackup,SYSDATETIME()) >= @TimeSinceLastLogBackup OR @CurrentLastLogBackup IS NULL))
    AND NOT (@CurrentBackupType = 'LOG' AND @Updateability = 'READ_ONLY' AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
    BEGIN

      IF @CurrentBackupType = 'LOG' AND (@CleanupTime IS NOT NULL OR @MirrorCleanupTime IS NOT NULL)
      BEGIN
        SELECT @CurrentLatestBackup = MAX(backup_start_date)
        FROM msdb.dbo.backupset
        WHERE ([type] IN('D','I')
        OR ([type] = 'L' AND last_lsn < @CurrentDifferentialBaseLSN))
        AND is_damaged = 0
        AND [database_name] = @CurrentDatabaseName
      END

      SET @CurrentDate = SYSDATETIME()

      INSERT INTO @CurrentCleanupDates (CleanupDate)
      SELECT @CurrentDate

      IF @CurrentBackupType = 'LOG'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate)
        SELECT @CurrentLatestBackup
      END

      SELECT @CurrentDirectoryStructure = CASE
      WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @AvailabilityGroupDirectoryStructure
      ELSE @DirectoryStructure
      END

      IF @CurrentDirectoryStructure IS NOT NULL
      BEGIN
      -- Directory structure - remove tokens that are not needed
        IF @ReadWriteFileGroups = 'N' SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Partial}','')
        IF @CopyOnly = 'N' SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{CopyOnly}','')
        IF @Cluster IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}','')
        IF @CurrentAvailabilityGroup IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}','')
        IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}','')
        IF @@SERVICENAME IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServiceName}','')
        IF @Description IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Description}','')

        IF @Directory IS NULL AND @MirrorDirectory IS NULL AND @URL IS NULL AND @DefaultDirectory LIKE '%' + '.' + @@SERVICENAME + @DirectorySeparator + 'MSSQL' + @DirectorySeparator + 'Backup'
        BEGIN
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServerName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}','')
        END

        WHILE (@Updated = 1 OR @Updated IS NULL)
        BEGIN
          SET @Updated = 0

          IF CHARINDEX('\',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'\','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('/',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'/','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('__',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'__','_')
            SET @Updated = 1
          END

          IF CHARINDEX('--',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'--','-')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}$','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('${DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'${DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}_',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}_','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('_{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'_{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}-',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}-','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('-{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'-{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('_$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'_$','_')
            SET @Updated = 1
          END
          IF CHARINDEX('$_',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'$_','_')
            SET @Updated = 1
          END

          IF CHARINDEX('-$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'-$','-')
            SET @Updated = 1
          END
          IF CHARINDEX('$-',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'$-','-')
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '_'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '_'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '-'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '-'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '$'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '$'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,20) = '{DirectorySeparator}'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 20)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,20) = '{DirectorySeparator}'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 20)
            SET @Updated = 1
          END
        END

        SET @Updated = NULL

        -- Directory structure - replace tokens with real values
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}',@DirectorySeparator)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServerName}',CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN LEFT(CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))) - 1) ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar(max)) END)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}',ISNULL(CAST(SERVERPROPERTY('InstanceName') AS nvarchar(max)),''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServiceName}',ISNULL(@@SERVICENAME,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}',ISNULL(@Cluster,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}',ISNULL(@CurrentAvailabilityGroup,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DatabaseName}',@CurrentDatabaseNameFS)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{BackupType}',@CurrentBackupType)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Partial}','PARTIAL')
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{CopyOnly}','COPY_ONLY')
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Description}',LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@Description,''),'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Year}',CAST(DATEPART(YEAR,@CurrentDate) AS nvarchar))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Month}',RIGHT('0' + CAST(DATEPART(MONTH,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Day}',RIGHT('0' + CAST(DATEPART(DAY,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Week}',RIGHT('0' + CAST(DATEPART(WEEK,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Hour}',RIGHT('0' + CAST(DATEPART(HOUR,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Minute}',RIGHT('0' + CAST(DATEPART(MINUTE,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Second}',RIGHT('0' + CAST(DATEPART(SECOND,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Millisecond}',RIGHT('00' + CAST(DATEPART(MILLISECOND,@CurrentDate) AS nvarchar),3))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Microsecond}',RIGHT('00000' + CAST(DATEPART(MICROSECOND,@CurrentDate) AS nvarchar),6))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{MajorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMajorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),4)))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{MinorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMinorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),3)))
      END

      INSERT INTO @CurrentDirectories (ID, DirectoryPath, Mirror, DirectoryNumber, CreateCompleted, CleanupCompleted)
      SELECT ROW_NUMBER() OVER (ORDER BY ID),
             DirectoryPath + CASE WHEN DirectoryPath = 'NUL' THEN '' WHEN @CurrentDirectoryStructure IS NOT NULL THEN @DirectorySeparator + @CurrentDirectoryStructure ELSE '' END,
             Mirror,
             ROW_NUMBER() OVER (PARTITION BY Mirror ORDER BY ID ASC),
             0,
             0
      FROM @Directories
      ORDER BY ID ASC

      INSERT INTO @CurrentURLs (ID, DirectoryPath, Mirror, DirectoryNumber)
      SELECT ROW_NUMBER() OVER (ORDER BY ID),
             DirectoryPath + CASE WHEN @CurrentDirectoryStructure IS NOT NULL THEN @DirectorySeparator + @CurrentDirectoryStructure ELSE '' END,
             Mirror,
             ROW_NUMBER() OVER (PARTITION BY Mirror ORDER BY ID ASC)
      FROM @URLs
      ORDER BY ID ASC

      SELECT @CurrentDatabaseFileName = CASE
      WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @AvailabilityGroupFileName
      ELSE @FileName
      END

      -- File name - remove tokens that are not needed
      IF @ReadWriteFileGroups = 'N' SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Partial}','')
      IF @CopyOnly = 'N' SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{CopyOnly}','')
      IF @Cluster IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ClusterName}','')
      IF @CurrentAvailabilityGroup IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{AvailabilityGroupName}','')
      IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{InstanceName}','')
      IF @@SERVICENAME IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServiceName}','')
      IF @Description IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Description}','')
      IF @CurrentNumberOfFiles = 1 SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{FileNumber}','')
      IF @CurrentNumberOfFiles = 1 SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{NumberOfFiles}','')

      WHILE (@Updated = 1 OR @Updated IS NULL)
      BEGIN
        SET @Updated = 0

        IF CHARINDEX('__',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'__','_')
          SET @Updated = 1
        END

        IF CHARINDEX('--',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'--','-')
          SET @Updated = 1
        END

        IF CHARINDEX('_$',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'_$','_')
          SET @Updated = 1
        END
        IF CHARINDEX('$_',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'$_','_')
          SET @Updated = 1
        END

        IF CHARINDEX('-$',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'-$','-')
          SET @Updated = 1
        END
        IF CHARINDEX('$-',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'$-','-')
          SET @Updated = 1
        END

        IF CHARINDEX('_.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'_.','.')
          SET @Updated = 1
        END

        IF CHARINDEX('-.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'-.','.')
          SET @Updated = 1
        END

        IF CHARINDEX('of.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'of.','.')
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '_'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '_'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '-'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '-'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '$'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '$'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
      END

      SET @Updated = NULL

      SELECT @CurrentFileExtension = CASE
      WHEN @CurrentBackupType = 'FULL' THEN @FileExtensionFull
      WHEN @CurrentBackupType = 'DIFF' THEN @FileExtensionDiff
      WHEN @CurrentBackupType = 'LOG' THEN @FileExtensionLog
      END

      -- File name - replace tokens with real values
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServerName}',CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN LEFT(CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))) - 1) ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar(max)) END)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{InstanceName}',ISNULL(CAST(SERVERPROPERTY('InstanceName') AS nvarchar(max)),''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServiceName}',ISNULL(@@SERVICENAME,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ClusterName}',ISNULL(@Cluster,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{AvailabilityGroupName}',ISNULL(@CurrentAvailabilityGroup,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{BackupType}',@CurrentBackupType)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Partial}','PARTIAL')
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{CopyOnly}','COPY_ONLY')
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Description}',LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@Description,''),'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Year}',CAST(DATEPART(YEAR,@CurrentDate) AS nvarchar))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Month}',RIGHT('0' + CAST(DATEPART(MONTH,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Day}',RIGHT('0' + CAST(DATEPART(DAY,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Week}',RIGHT('0' + CAST(DATEPART(WEEK,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Hour}',RIGHT('0' + CAST(DATEPART(HOUR,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Minute}',RIGHT('0' + CAST(DATEPART(MINUTE,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Second}',RIGHT('0' + CAST(DATEPART(SECOND,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Millisecond}',RIGHT('00' + CAST(DATEPART(MILLISECOND,@CurrentDate) AS nvarchar),3))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Microsecond}',RIGHT('00000' + CAST(DATEPART(MICROSECOND,@CurrentDate) AS nvarchar),6))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{NumberOfFiles}',@CurrentNumberOfFiles)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{FileExtension}',@CurrentFileExtension)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{MajorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMajorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),4)))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{MinorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMinorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),3)))

      SELECT @CurrentMaxFilePathLength = CASE
      WHEN EXISTS (SELECT * FROM @CurrentDirectories) THEN (SELECT MAX(LEN(DirectoryPath + @DirectorySeparator)) FROM @CurrentDirectories)
      WHEN EXISTS (SELECT * FROM @CurrentURLs) THEN (SELECT MAX(LEN(DirectoryPath + @DirectorySeparator)) FROM @CurrentURLs)
      END
      + LEN(REPLACE(REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',@CurrentDatabaseNameFS), '{FileNumber}', CASE WHEN @CurrentNumberOfFiles >= 1 AND @CurrentNumberOfFiles <= 9 THEN '1' WHEN @CurrentNumberOfFiles >= 10 THEN '01' END))

      -- The maximum length of a backup device is 259 characters
      IF @CurrentMaxFilePathLength > 259
      BEGIN
        SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - @CurrentMaxFilePathLength - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - @CurrentMaxFilePathLength - 3) END) + '...')
      END
      ELSE
      BEGIN
        SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',@CurrentDatabaseNameFS)
      END

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 0)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0)
          AND Mirror = 0

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles >= 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) END)

          IF @CurrentDirectoryPath = 'NUL'
          BEGIN
            SET @CurrentFilePath = 'NUL'
          END
          ELSE
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName
          END

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 0

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 1)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1)
          AND Mirror = 1

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 1

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 1, 0
      END

      IF EXISTS (SELECT * FROM @CurrentURLs WHERE Mirror = 0)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentURLs
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0)
          AND Mirror = 0

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'URL', @CurrentFilePath, 0

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END

      IF EXISTS (SELECT * FROM @CurrentURLs WHERE Mirror = 1)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentURLs
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0)
          AND Mirror = 1

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'URL', @CurrentFilePath, 1

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 1, 0
      END

      -- Create directory
      IF @HostPlatform = 'Windows'
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND NOT EXISTS(SELECT * FROM @CurrentDirectories WHERE DirectoryPath = 'NUL')
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE CreateCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'xp_create_subdir'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_create_subdir N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CreateCompleted = 1,
              CreateOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      IF @CleanupMode = 'BEFORE_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),SYSDATETIME()), 0

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
        SELECT DATEADD(hh,-(@MirrorCleanupTime),SYSDATETIME()), 1

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
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupMode = 'BEFORE_BACKUP'
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_delete_file'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_slssqlmaint'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqbutility'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_delete'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Perform a backup
      IF NOT EXISTS (SELECT * FROM @CurrentDirectories WHERE DirectoryPath <> 'NUL' AND (CreateOutput <> 0 OR CreateOutput IS NULL)) OR @HostPlatform = 'Linux'
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SELECT @CurrentCommandType = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP_DATABASE'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP_LOG'
          END

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand += ' TO'

          SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ' MIRROR TO'

            SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand += ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'

          IF @Version >= 10
          BEGIN
            SET @CurrentCommand += CASE WHEN @Compress = 'Y' AND (@CurrentIsEncrypted = 0 OR (@CurrentIsEncrypted = 1 AND ((@Version >= 13 AND @CurrentMaxTransferSize >= 65537) OR @Version >= 15.0404316 OR SERVERPROPERTY('EngineEdition') = 8))) THEN ', COMPRESSION' ELSE ', NO_COMPRESSION' END
          END

          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ', FORMAT'
          END

          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @Init = 'Y' SET @CurrentCommand += ', INIT'
          IF @Format = 'Y' SET @CurrentCommand += ', FORMAT'
          IF @BlockSize IS NOT NULL SET @CurrentCommand += ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand += ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', MAXTRANSFERSIZE = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''
          IF @Encrypt = 'Y' SET @CurrentCommand += ', ENCRYPTION (ALGORITHM = ' + UPPER(@EncryptionAlgorithm) + ', '
          IF @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL SET @CurrentCommand += 'SERVER CERTIFICATE = ' + QUOTENAME(@ServerCertificate)
          IF @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL SET @CurrentCommand += 'SERVER ASYMMETRIC KEY = ' + QUOTENAME(@ServerAsymmetricKey)
          IF @Encrypt = 'Y' SET @CurrentCommand += ')'
          IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand += ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SELECT @CurrentCommandType = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'xp_backup_database'
          WHEN @CurrentBackupType = 'LOG' THEN 'xp_backup_log'
          END

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_backup_database @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          WHEN @CurrentBackupType = 'LOG' THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_backup_log @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          END

          SELECT @CurrentCommand += ', @filename = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SELECT @CurrentCommand += ', @mirror = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand += ', @with = '''
          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand += ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          SET @CurrentCommand += ''''
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ', @read_write_filegroups = 1'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @AdaptiveCompression IS NOT NULL SET @CurrentCommand += ', @adaptivecompression = ''' + CASE WHEN @AdaptiveCompression = 'SIZE' THEN 'Size' WHEN @AdaptiveCompression = 'SPEED' THEN 'Speed' END + ''''
          IF @BufferCount IS NOT NULL SET @CurrentCommand += ', @buffercount = ' + CAST(@BufferCount AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', @maxtransfersize = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Init = 'Y' SET @CurrentCommand += ', @init = 1'
          IF @Format = 'Y' SET @CurrentCommand += ', @format = 1'
          IF @Throttle IS NOT NULL SET @CurrentCommand += ', @throttle = ' + CAST(@Throttle AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''
          IF @ObjectLevelRecoveryMap = 'Y' SET @CurrentCommand += ', @olrmap = 1'

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', @cryptlevel = ' + CASE
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

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing LiteSpeed backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'sqlbackup'

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand += ' TO'

          SELECT @CurrentCommand += ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SET @CurrentCommand += ' WITH '

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ' MIRRORFILE' + ' = N''' + REPLACE((SELECT FilePath FROM @CurrentFiles WHERE Mirror = 1),'''','''''') + ''', '
          END

          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @Init = 'Y' SET @CurrentCommand += ', INIT'
          IF @Format = 'Y' SET @CurrentCommand += ', FORMAT'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', COMPRESSION = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', THREADCOUNT = ' + CAST(@Threads AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', MAXTRANSFERSIZE = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', KEYSIZE = ' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN '128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN '256'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLBackup backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'xp_ss_backup'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_backup @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

          SELECT @CurrentCommand += ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SELECT @CurrentCommand += ', @mirrorfile = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 1
          ORDER BY FilePath ASC

          SET @CurrentCommand += ', @backuptype = ' + CASE WHEN @CurrentBackupType = 'FULL' THEN '''Full''' WHEN @CurrentBackupType = 'DIFF' THEN '''Differential''' WHEN @CurrentBackupType = 'LOG' THEN '''Log''' END
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ', @readwritefilegroups = 1'
          SET @CurrentCommand += ', @checksum = ' + CASE WHEN @CheckSum = 'Y' THEN '1' WHEN @CheckSum = 'N' THEN '0' END
          SET @CurrentCommand += ', @copyonly = ' + CASE WHEN @CopyOnly = 'Y' THEN '1' WHEN @CopyOnly = 'N' THEN '0' END
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Init = 'Y' SET @CurrentCommand += ', @overwrite = 1'
          IF @Description IS NOT NULL SET @CurrentCommand += ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', @encryptiontype = N''' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN 'AES128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN 'AES256'
          END + ''''

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptedbackuppassword = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLsafe backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'DATA_DOMAIN_BOOST'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'emc_run_backup'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.emc_run_backup '''

          SET @CurrentCommand += ' -c ' + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar) END

          SET @CurrentCommand += ' -l ' + CASE
          WHEN @CurrentBackupType = 'FULL' THEN 'full'
          WHEN @CurrentBackupType = 'DIFF' THEN 'diff'
          WHEN @CurrentBackupType = 'LOG' THEN 'incr'
          END

          IF @NoRecovery = 'Y' SET @CurrentCommand += ' -H'

          IF @CleanupTime IS NOT NULL SET @CurrentCommand += ' -y +' + CAST(@CleanupTime/24 + CASE WHEN @CleanupTime%24 > 0 THEN 1 ELSE 0 END AS nvarchar) + 'd'

          IF @CheckSum = 'Y' SET @CurrentCommand += ' -k'

          SET @CurrentCommand += ' -S ' + CAST(@CurrentNumberOfFiles AS nvarchar)

          IF @Description IS NOT NULL SET @CurrentCommand += ' -b "' + REPLACE(@Description,'''','''''') + '"'

          IF @BufferCount IS NOT NULL SET @CurrentCommand += ' -O "BUFFERCOUNT=' + CAST(@BufferCount AS nvarchar) + '"'

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' -O "READ_WRITE_FILEGROUPS"'

          IF @DataDomainBoostHost IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_HOST=' + REPLACE(@DataDomainBoostHost,'''','''''') + '"'
          IF @DataDomainBoostUser IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_USER=' + REPLACE(@DataDomainBoostUser,'''','''''') + '"'
          IF @DataDomainBoostDevicePath IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DEVICE_PATH=' + REPLACE(@DataDomainBoostDevicePath,'''','''''') + '"'
          IF @DataDomainBoostLockboxPath IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_LOCKBOX_PATH=' + REPLACE(@DataDomainBoostLockboxPath,'''','''''') + '"'
          SET @CurrentCommand += ' -a "NSR_SKIP_NON_BACKUPABLE_STATE_DB=TRUE"'
          SET @CurrentCommand += ' -a "BACKUP_PROMOTION=NONE"'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ' -a "NSR_COPY_ONLY=TRUE"'

          IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentCommand += ' "MSSQL' + ':' + REPLACE(REPLACE(@CurrentDatabaseName,'''',''''''),'.','\.') + '"'
          IF SERVERPROPERTY('InstanceName') IS NOT NULL SET @CurrentCommand += ' "MSSQL$' + CAST(SERVERPROPERTY('InstanceName') AS nvarchar) + ':' + REPLACE(REPLACE(@CurrentDatabaseName,'''',''''''),'.','\.') + '"'

          SET @CurrentCommand += ''''

          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing Data Domain Boost backup.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
        SET @CurrentBackupOutput = @CurrentCommandOutput
      END

      -- Verify the backup
      IF @CurrentBackupOutput = 0 AND @Verify = 'Y'
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentBackupSetID = ID,
                       @CurrentIsMirror = Mirror
          FROM @CurrentBackupSet
          WHERE VerifyCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'RESTORE_VERIFYONLY'

            SET @CurrentCommand = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand += ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_restore_verifyonly'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_restore_verifyonly'

            SELECT @CurrentCommand += ' @filename = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ', @with = '''
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            SET @CurrentCommand += ''''
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error verifying LiteSpeed backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqlbackup'

            SET @CurrentCommand = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand += ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLBackup backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_verify'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_verify @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

            SELECT @CurrentCommand += ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLsafe backup.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentBackupSet
          SET VerifyCompleted = 1,
              VerifyOutput = @CurrentCommandOutput
          WHERE ID = @CurrentBackupSetID

          SET @CurrentBackupSetID = NULL
          SET @CurrentIsMirror = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      IF @CleanupMode = 'AFTER_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),SYSDATETIME()), 0

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
        SELECT DATEADD(hh,-(@MirrorCleanupTime),SYSDATETIME()), 1

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
      IF ((@CurrentBackupOutput = 0 AND @Verify = 'N')
      OR (@CurrentBackupOutput = 0 AND @Verify = 'Y' AND NOT EXISTS (SELECT * FROM @CurrentBackupSet WHERE VerifyOutput <> 0 OR VerifyOutput IS NULL)))
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupMode = 'AFTER_BACKUP'
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_delete_file'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_slssqlmaint'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqbutility'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_delete'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END
    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      SET @Error = @@ERROR
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL
    SET @CurrentIsEncrypted = NULL
    SET @CurrentDatabaseSize = NULL

    SET @CurrentBackupType = NULL
    SET @CurrentMaxTransferSize = NULL
    SET @CurrentNumberOfFiles = NULL
    SET @CurrentFileExtension = NULL
    SET @CurrentFileNumber = NULL
    SET @CurrentDifferentialBaseLSN = NULL
    SET @CurrentDifferentialBaseIsSnapshot = NULL
    SET @CurrentLogLSN = NULL
    SET @CurrentLatestBackup = NULL
    SET @CurrentDatabaseNameFS = NULL
    SET @CurrentDirectoryStructure = NULL
    SET @CurrentDatabaseFileName = NULL
    SET @CurrentMaxFilePathLength = NULL
    SET @CurrentDate = NULL
    SET @CurrentCleanupDate = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentAvailabilityGroupBackupPreference = NULL
    SET @CurrentIsPreferredBackupReplica = NULL
    SET @CurrentDatabaseMirroringRole = NULL
    SET @CurrentLogShippingRole = NULL
    SET @CurrentLastLogBackup = NULL
    SET @CurrentLogSizeSinceLastLogBackup = NULL
    SET @CurrentAllocatedExtentPageCount = NULL
    SET @CurrentModifiedExtentPageCount = NULL

    SET @CurrentDatabaseContext = NULL
    SET @CurrentCommand = NULL
    SET @CurrentCommandOutput = NULL
    SET @CurrentCommandType = NULL

    SET @CurrentBackupOutput = NULL

    DELETE FROM @CurrentDirectories
    DELETE FROM @CurrentURLs
    DELETE FROM @CurrentFiles
    DELETE FROM @CurrentCleanupDates
    DELETE FROM @CurrentBackupSet

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseIntegrityCheck]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DatabaseIntegrityCheck] AS'
END
GO
ALTER PROCEDURE [dbo].[DatabaseIntegrityCheck]

@Databases nvarchar(max) = NULL,
@CheckCommands nvarchar(max) = 'CHECKDB',
@PhysicalOnly nvarchar(max) = 'N',
@DataPurity nvarchar(max) = 'N',
@NoIndex nvarchar(max) = 'N',
@ExtendedLogicalChecks nvarchar(max) = 'N',
@TabLock nvarchar(max) = 'N',
@FileGroups nvarchar(max) = NULL,
@Objects nvarchar(max) = NULL,
@MaxDOP int = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@AvailabilityGroupReplicas nvarchar(max) = 'ALL',
@Updateability nvarchar(max) = 'ALL',
@TimeLimit int = NULL,
@LockTimeout int = NULL,
@LockMessageSeverity int = 16,
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @Severity int

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)

  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentAvailabilityGroupBackupPreference nvarchar(max)
  DECLARE @CurrentSecondaryRoleAllowConnections nvarchar(max)
  DECLARE @CurrentIsPreferredBackupReplica bit
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)

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

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               [Snapshot] bit,
                               StartPosition int,
                               LastCommandTime datetime2,
                               DatabaseSize bigint,
                               LastGoodCheckDbTime datetime2,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @tmpFileGroups TABLE (ID int IDENTITY,
                                FileGroupID int,
                                FileGroupName nvarchar(max),
                                StartPosition int,
                                [Order] int,
                                Selected bit,
                                Completed bit,
                                PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpObjects TABLE (ID int IDENTITY,
                             SchemaID int,
                             SchemaName nvarchar(max),
                             ObjectID int,
                             ObjectName nvarchar(max),
                             ObjectType nvarchar(max),
                             StartPosition int,
                             [Order] int,
                             Selected bit,
                             Completed bit,
                             PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @SelectedFileGroups TABLE (DatabaseName nvarchar(max),
                                     FileGroupName nvarchar(max),
                                     StartPosition int,
                                     Selected bit)

  DECLARE @SelectedObjects TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  StartPosition int,
                                  Selected bit)

  DECLARE @SelectedCheckCommands TABLE (CheckCommand nvarchar(max))

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @CheckCommands = ' + ISNULL('''' + REPLACE(@CheckCommands,'''','''''') + '''','NULL')
  SET @Parameters += ', @PhysicalOnly = ' + ISNULL('''' + REPLACE(@PhysicalOnly,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataPurity = ' + ISNULL('''' + REPLACE(@DataPurity,'''','''''') + '''','NULL')
  SET @Parameters += ', @NoIndex = ' + ISNULL('''' + REPLACE(@NoIndex,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExtendedLogicalChecks = ' + ISNULL('''' + REPLACE(@ExtendedLogicalChecks,'''','''''') + '''','NULL')
  SET @Parameters += ', @TabLock = ' + ISNULL('''' + REPLACE(@TabLock,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileGroups = ' + ISNULL('''' + REPLACE(@FileGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @Objects = ' + ISNULL('''' + REPLACE(@Objects,'''','''''') + '''','NULL')
  SET @Parameters += ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupReplicas = ' + ISNULL('''' + REPLACE(@AvailabilityGroupReplicas,'''','''''') + '''','NULL')
  SET @Parameters += ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @Parameters += ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @Parameters += ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @Parameters += ', @LockMessageSeverity = ' + ISNULL(CAST(@LockMessageSeverity AS nvarchar),'NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT  'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Snapshot], [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         CASE WHEN source_database_id IS NOT NULL THEN 1 ELSE 0 END AS [Snapshot],
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

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

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

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

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Select filegroups                                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET @FileGroups = REPLACE(@FileGroups, CHAR(10), '')
  SET @FileGroups = REPLACE(@FileGroups, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups, ' ' + @StringDelimiter, @StringDelimiter)

  SET @FileGroups = LTRIM(RTRIM(@FileGroups));

  WITH FileGroups1 (StartPosition, EndPosition, FileGroupItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, 1), 0), LEN(@FileGroups) + 1) - 1) AS FileGroupItem
  WHERE @FileGroups IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) - EndPosition - 1) AS FileGroupItem
  FROM FileGroups1
  WHERE EndPosition < LEN(@FileGroups) + 1
  ),
  FileGroups2 (FileGroupItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem LIKE '-%' THEN RIGHT(FileGroupItem,LEN(FileGroupItem) - 1) ELSE FileGroupItem END AS FileGroupItem,
         StartPosition,
         CASE WHEN FileGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM FileGroups1
  ),
  FileGroups3 (FileGroupItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem = 'ALL_FILEGROUPS' THEN '%.%' ELSE FileGroupItem END AS FileGroupItem,
         StartPosition,
         Selected
  FROM FileGroups2
  ),
  FileGroups4 (DatabaseName, FileGroupName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,2) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,1) ELSE NULL END AS FileGroupName,
         StartPosition,
         Selected
  FROM FileGroups3
  )
  INSERT INTO @SelectedFileGroups (DatabaseName, FileGroupName, StartPosition, Selected)
  SELECT DatabaseName, FileGroupName, StartPosition, Selected
  FROM FileGroups4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select objects                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Objects = REPLACE(@Objects, CHAR(10), '')
  SET @Objects = REPLACE(@Objects, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Objects) > 0 SET @Objects = REPLACE(@Objects, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Objects) > 0 SET @Objects = REPLACE(@Objects, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Objects = LTRIM(RTRIM(@Objects));

  WITH Objects1 (StartPosition, EndPosition, ObjectItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, 1), 0), LEN(@Objects) + 1) - 1) AS ObjectItem
  WHERE @Objects IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) - EndPosition - 1) AS ObjectItem
  FROM Objects1
  WHERE EndPosition < LEN(@Objects) + 1
  ),
  Objects2 (ObjectItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN ObjectItem LIKE '-%' THEN RIGHT(ObjectItem,LEN(ObjectItem) - 1) ELSE ObjectItem END AS ObjectItem,
          StartPosition,
         CASE WHEN ObjectItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Objects1
  ),
  Objects3 (ObjectItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN ObjectItem = 'ALL_OBJECTS' THEN '%.%.%' ELSE ObjectItem END AS ObjectItem,
         StartPosition,
         Selected
  FROM Objects2
  ),
  Objects4 (DatabaseName, SchemaName, ObjectName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,3) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,2) ELSE NULL END AS SchemaName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,1) ELSE NULL END AS ObjectName,
         StartPosition,
         Selected
  FROM Objects3
  )
  INSERT INTO @SelectedObjects (DatabaseName, SchemaName, ObjectName, StartPosition, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, StartPosition, Selected
  FROM Objects4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select check commands                                                                      //--
  ----------------------------------------------------------------------------------------------------

  SET @CheckCommands = REPLACE(@CheckCommands, @StringDelimiter + ' ', @StringDelimiter);

  WITH CheckCommands (StartPosition, EndPosition, CheckCommand) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) - 1) AS CheckCommand
  WHERE @CheckCommands IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) - EndPosition - 1) AS CheckCommand
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

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand NOT IN('CHECKDB','CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands GROUP BY CheckCommand HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 2
  END

  IF NOT EXISTS (SELECT * FROM @SelectedCheckCommands)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.' , 16, 3
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKDB')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 4
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKALLOC','CHECKTABLE'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @PhysicalOnly NOT IN ('Y','N') OR @PhysicalOnly IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PhysicalOnly is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataPurity NOT IN ('Y','N') OR @DataPurity IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataPurity is not supported.', 16, 1
  END

  IF @PhysicalOnly = 'Y' AND @DataPurity = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @PhysicalOnly and @DataPurity cannot be used together.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @NoIndex NOT IN ('Y','N') OR @NoIndex IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoIndex is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @ExtendedLogicalChecks NOT IN ('Y','N') OR @ExtendedLogicalChecks IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExtendedLogicalChecks is not supported.', 16, 1
  END

  IF @PhysicalOnly = 'Y' AND @ExtendedLogicalChecks = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @PhysicalOnly and @ExtendedLogicalChecks cannot be used together.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TabLock NOT IN ('Y','N') OR @TabLock IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TabLock is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedFileGroups WHERE DatabaseName IS NULL OR FileGroupName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 1
  END

  IF @FileGroups IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedFileGroups)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 2
  END

  IF @FileGroups IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedObjects WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 1
  END

  IF (@Objects IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedObjects))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 2
  END

  IF (@Objects IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxDOP < 0 OR @MaxDOP > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported.', 16, 1
  END

  IF @MaxDOP IS NOT NULL AND NOT (@Version >= 12.050000 OR SERVERPROPERTY('EngineEdition') IN (5, 8))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported. MAXDOP is not available in this version of SQL Server.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroupReplicas NOT IN('ALL','PRIMARY','SECONDARY','PREFERRED_BACKUP_REPLICA') OR @AvailabilityGroupReplicas IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupReplicas is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Updateability is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeLimit < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeLimit is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockTimeout < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockTimeout is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockMessageSeverity NOT IN(10, 16)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC','DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC','REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC') AND NOT ((@Version >= 12.06024 AND @Version < 13) OR (@Version >= 13.05026 AND @Version < 14) OR @Version >= 14.0302916)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. DATABASEPROPERTYEX(''DatabaseName'', ''LastGoodCheckDbTime'') is not available in this version of SQL Server.', 16, 2
  END

  IF @DatabaseOrder IN('REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC') AND @LogToTable = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. You need to provide the parameter @LogToTable = ''Y''.', 16, 3
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC','REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC') AND @CheckCommands <> 'CHECKDB'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. You need to provide the parameter @CheckCommands = ''CHECKDB''.', 16, 4
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. This parameter is not supported in Azure SQL Database.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported. This parameter is not supported in Azure SQL Database.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-integrity-check.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedFileGroups
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @FileGroups parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedObjects
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Objects parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedFileGroups
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @FileGroups parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedObjects
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @Objects parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check @@SERVERNAME                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @@SERVERNAME <> CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The @@SERVERNAME does not match SERVERPROPERTY(''ServerName''). See ' + CASE WHEN SERVERPROPERTY('IsClustered') = 0 THEN 'https://docs.microsoft.com/en-us/sql/database-engine/install-windows/rename-a-computer-that-hosts-a-stand-alone-instance-of-sql-server' WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'https://docs.microsoft.com/en-us/sql/sql-server/failover-clusters/install/rename-a-sql-server-failover-cluster-instance' END + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LastGoodCheckDbTime = NULLIF(CAST(DATABASEPROPERTYEX (DatabaseName,'LastGoodCheckDbTime') AS datetime2),'1900-01-01 00:00:00.000')
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LastCommandTime = MaxStartTime
    FROM @tmpDatabases tmpDatabases
    INNER JOIN (SELECT DatabaseName, MAX(StartTime) AS MaxStartTime
                FROM dbo.CommandLog
                WHERE CommandType = 'DBCC_CHECKDB'
                AND ErrorNumber = 0
                GROUP BY DatabaseName) CommandLog
    ON tmpDatabases.DatabaseName = CommandLog.DatabaseName COLLATE DATABASE_DEFAULT
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_LAST_GOOD_CHECK_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastGoodCheckDbTime ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_LAST_GOOD_CHECK_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastGoodCheckDbTime DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'REPLICA_LAST_GOOD_CHECK_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastCommandTime ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'REPLICA_LAST_GOOD_CHECK_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastCommandTime DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
     BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id,
             @CurrentSecondaryRoleAllowConnections = secondary_role_allow_connections_desc
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name],
             @CurrentAvailabilityGroupBackupPreference = UPPER(automated_backup_preference_desc)
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1 AND @CurrentAvailabilityGroup IS NOT NULL AND @AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA'
    BEGIN
      SELECT @CurrentIsPreferredBackupReplica = sys.fn_hadr_backup_is_preferred_replica(@CurrentDatabaseName)
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage =  'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      IF @CurrentAvailabilityGroupRole = 'SECONDARY'
      BEGIN
        SET @DatabaseMessage =  'Readable Secondary: ' + ISNULL(@CurrentSecondaryRoleAllowConnections,'N/A')
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
      END

      IF @AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA'
      BEGIN
        SET @DatabaseMessage = 'Availability group backup preference: ' + ISNULL(@CurrentAvailabilityGroupBackupPreference,'N/A')
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

        SET @DatabaseMessage = 'Is preferred backup replica: ' + CASE WHEN @CurrentIsPreferredBackupReplica = 1 THEN 'Yes' WHEN @CurrentIsPreferredBackupReplica = 0 THEN 'No' ELSE 'N/A' END
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
      END
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL OR SERVERPROPERTY('EngineEdition') = 3)
    AND ((@AvailabilityGroupReplicas = 'PRIMARY' AND @CurrentAvailabilityGroupRole = 'PRIMARY') OR (@AvailabilityGroupReplicas = 'SECONDARY' AND @CurrentAvailabilityGroupRole = 'SECONDARY') OR (@AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA' AND @CurrentIsPreferredBackupReplica = 1) OR @AvailabilityGroupReplicas = 'ALL' OR @CurrentAvailabilityGroupRole IS NULL)
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    BEGIN

      -- Check database
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKDB') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKDB'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKDB (' + QUOTENAME(@CurrentDatabaseName)
        IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
        SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @DataPurity = 'Y' SET @CurrentCommand += ', DATA_PURITY'
        IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
        IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand += ', EXTENDED_LOGICAL_CHECKS'
        IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
        IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

      -- Check filegroups
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP')
      AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR (@CurrentAvailabilityGroupRole = 'SECONDARY' AND @CurrentSecondaryRoleAllowConnections = 'ALL') OR @CurrentAvailabilityGroupRole IS NULL)
      AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT data_space_id AS FileGroupID, name AS FileGroupName, 0 AS [Order], 0 AS Selected, 0 AS Completed FROM sys.filegroups filegroups WHERE [type] <> ''FX'' ORDER BY CASE WHEN filegroups.name = ''PRIMARY'' THEN 1 ELSE 0 END DESC, filegroups.name ASC'

        INSERT INTO @tmpFileGroups (FileGroupID, FileGroupName, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql  @stmt = @CurrentCommand
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

          UPDATE tmpFileGroups
          SET tmpFileGroups.StartPosition = SelectedFileGroups2.StartPosition
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN (SELECT tmpFileGroups.FileGroupName, MIN(SelectedFileGroups.StartPosition) AS StartPosition
                      FROM @tmpFileGroups tmpFileGroups
                      INNER JOIN @SelectedFileGroups SelectedFileGroups
                      ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
                      WHERE SelectedFileGroups.Selected = 1
                      GROUP BY tmpFileGroups.FileGroupName) SelectedFileGroups2
          ON tmpFileGroups.FileGroupName = SelectedFileGroups2.FileGroupName
        END;

        WITH tmpFileGroups AS (
        SELECT FileGroupName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, FileGroupName ASC) AS RowNumber
        FROM @tmpFileGroups tmpFileGroups
        WHERE Selected = 1
        )
        UPDATE tmpFileGroups
        SET [Order] = RowNumber

        SET @ErrorMessage = ''
        SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(FileGroupName) + ', '
        FROM @SelectedFileGroups SelectedFileGroups
        WHERE DatabaseName = @CurrentDatabaseName
        AND FileGroupName NOT LIKE '%[%]%'
        AND NOT EXISTS (SELECT * FROM @tmpFileGroups WHERE FileGroupName = SelectedFileGroups.FileGroupName)
        IF @@ROWCOUNT > 0
        BEGIN
          SET @ErrorMessage = 'The following file groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
          RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
          SET @Error = @@ERROR
          RAISERROR(@EmptyLine,10,1) WITH NOWAIT
        END

        WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SELECT TOP 1 @CurrentFGID = ID,
                       @CurrentFileGroupID = FileGroupID,
                       @CurrentFileGroupName = FileGroupName
          FROM @tmpFileGroups
          WHERE Selected = 1
          AND Completed = 0
          ORDER BY [Order] ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          -- Does the filegroup exist?
          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.filegroups filegroups WHERE [type] <> ''FX'' AND filegroups.data_space_id = @ParamFileGroupID AND filegroups.[name] = @ParamFileGroupName) BEGIN SET @ParamFileGroupExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamFileGroupID int, @ParamFileGroupName sysname, @ParamFileGroupExists bit OUTPUT', @ParamFileGroupID = @CurrentFileGroupID, @ParamFileGroupName = @CurrentFileGroupName, @ParamFileGroupExists = @CurrentFileGroupExists OUTPUT

            IF @CurrentFileGroupExists IS NULL SET @CurrentFileGroupExists = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ', ' + ' The file group ' + QUOTENAME(@CurrentFileGroupName) + ' in the database ' + QUOTENAME(@CurrentDatabaseName) + ' is locked. It could not be checked if the filegroup exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END
          END CATCH

          IF @CurrentFileGroupExists = 1
          BEGIN
            SET @CurrentDatabaseContext = @CurrentDatabaseName

            SET @CurrentCommandType = 'DBCC_CHECKFILEGROUP'

            SET @CurrentCommand = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand += 'DBCC CHECKFILEGROUP (' + QUOTENAME(@CurrentFileGroupName)
            IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
            SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
            IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput = @Error
            IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
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

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Check disk space allocation structures
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKALLOC') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKALLOC'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKALLOC (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

      -- Check objects
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE')
      AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR (@CurrentAvailabilityGroupRole = 'SECONDARY' AND @CurrentSecondaryRoleAllowConnections = 'ALL') OR @CurrentAvailabilityGroupRole IS NULL)
      AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, 0 AS [Order], 0 AS Selected, 0 AS Completed FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' ORDER BY schemas.name ASC, objects.name ASC'

        INSERT INTO @tmpObjects (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand
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

          UPDATE tmpObjects
          SET tmpObjects.StartPosition = SelectedObjects2.StartPosition
          FROM @tmpObjects tmpObjects
          INNER JOIN (SELECT tmpObjects.SchemaName, tmpObjects.ObjectName, MIN(SelectedObjects.StartPosition) AS StartPosition
                      FROM @tmpObjects tmpObjects
                      INNER JOIN @SelectedObjects SelectedObjects
                      ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
                      WHERE SelectedObjects.Selected = 1
                      GROUP BY tmpObjects.SchemaName, tmpObjects.ObjectName) SelectedObjects2
          ON tmpObjects.SchemaName = SelectedObjects2.SchemaName AND tmpObjects.ObjectName = SelectedObjects2.ObjectName
        END;

        WITH tmpObjects AS (
        SELECT SchemaName, ObjectName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, SchemaName ASC, ObjectName ASC) AS RowNumber
        FROM @tmpObjects tmpObjects
        WHERE Selected = 1
        )
        UPDATE tmpObjects
        SET [Order] = RowNumber

        SET @ErrorMessage = ''
        SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + ', '
        FROM @SelectedObjects SelectedObjects
        WHERE DatabaseName = @CurrentDatabaseName
        AND SchemaName NOT LIKE '%[%]%'
        AND ObjectName NOT LIKE '%[%]%'
        AND NOT EXISTS (SELECT * FROM @tmpObjects WHERE SchemaName = SelectedObjects.SchemaName AND ObjectName = SelectedObjects.ObjectName)
        IF @@ROWCOUNT > 0
        BEGIN
          SET @ErrorMessage = 'The following objects do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
          RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
          SET @Error = @@ERROR
          RAISERROR(@EmptyLine,10,1) WITH NOWAIT
        END

        WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
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
          ORDER BY [Order] ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          -- Does the object exist?
          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType) BEGIN SET @ParamObjectExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamObjectExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamObjectExists = @CurrentObjectExists OUTPUT

            IF @CurrentObjectExists IS NULL SET @CurrentObjectExists = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ', ' + 'The object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the object exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END
          END CATCH

          IF @CurrentObjectExists = 1
          BEGIN
            SET @CurrentDatabaseContext = @CurrentDatabaseName

            SET @CurrentCommandType = 'DBCC_CHECKTABLE'

            SET @CurrentCommand = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand += 'DBCC CHECKTABLE (''' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ''''
            IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
            SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @DataPurity = 'Y' SET @CurrentCommand += ', DATA_PURITY'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
            IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand += ', EXTENDED_LOGICAL_CHECKS'
            IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput = @Error
            IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
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

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Check catalog
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKCATALOG') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKCATALOG'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKCATALOG (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand += ') WITH NO_INFOMSGS'

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      SET @Error = @@ERROR
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL

    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentAvailabilityGroupBackupPreference = NULL
    SET @CurrentSecondaryRoleAllowConnections = NULL
    SET @CurrentIsPreferredBackupReplica = NULL
    SET @CurrentDatabaseMirroringRole = NULL

    SET @CurrentDatabaseContext = NULL
    SET @CurrentCommand = NULL
    SET @CurrentCommandOutput = NULL
    SET @CurrentCommandType = NULL

    DELETE FROM @tmpFileGroups
    DELETE FROM @tmpObjects

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndexOptimize]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IndexOptimize] AS'
END
GO
ALTER PROCEDURE [dbo].[IndexOptimize]

@Databases nvarchar(max) = NULL,
@FragmentationLow nvarchar(max) = NULL,
@FragmentationMedium nvarchar(max) = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh nvarchar(max) = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 int = 5,
@FragmentationLevel2 int = 30,
@MinNumberOfPages int = 1000,
@MaxNumberOfPages int = NULL,
@SortInTempdb nvarchar(max) = 'N',
@MaxDOP int = NULL,
@FillFactor int = NULL,
@PadIndex nvarchar(max) = NULL,
@LOBCompaction nvarchar(max) = 'Y',
@UpdateStatistics nvarchar(max) = NULL,
@OnlyModifiedStatistics nvarchar(max) = 'N',
@StatisticsModificationLevel int = NULL,
@StatisticsSample int = NULL,
@StatisticsResample nvarchar(max) = 'N',
@PartitionLevel nvarchar(max) = 'Y',
@MSShippedObjects nvarchar(max) = 'N',
@Indexes nvarchar(max) = NULL,
@TimeLimit int = NULL,
@Delay int = NULL,
@WaitAtLowPriorityMaxDuration int = NULL,
@WaitAtLowPriorityAbortAfterWait nvarchar(max) = NULL,
@Resumable nvarchar(max) = 'N',
@AvailabilityGroups nvarchar(max) = NULL,
@LockTimeout int = NULL,
@LockMessageSeverity int = 16,
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET ARITHABORT ON

  SET NUMERIC_ROUNDABORT OFF

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @Severity int

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)

  DECLARE @PartitionLevelStatistics bit

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentExecuteAsUserExists bit
  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)

  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)
  DECLARE @CurrentComment nvarchar(max)
  DECLARE @CurrentExtendedInfo xml

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @CurrentIxID int
  DECLARE @CurrentIxOrder int
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
  DECLARE @CurrentIsComputed bit
  DECLARE @CurrentIsTimestamp bit
  DECLARE @CurrentAllowPageLocks bit
  DECLARE @CurrentNoRecompute bit
  DECLARE @CurrentIsIncremental bit
  DECLARE @CurrentRowCount bigint
  DECLARE @CurrentModificationCounter bigint
  DECLARE @CurrentOnReadOnlyFileGroup bit
  DECLARE @CurrentResumableIndexOperation bit
  DECLARE @CurrentFragmentationLevel float
  DECLARE @CurrentPageCount bigint
  DECLARE @CurrentFragmentationGroup nvarchar(max)
  DECLARE @CurrentAction nvarchar(max)
  DECLARE @CurrentMaxDOP int
  DECLARE @CurrentUpdateStatistics nvarchar(max)
  DECLARE @CurrentStatisticsSample int
  DECLARE @CurrentStatisticsResample nvarchar(max)
  DECLARE @CurrentDelay datetime

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               StartPosition int,
                               DatabaseSize bigint,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

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
                                       AllowPageLocks bit,
                                       IsImageText bit,
                                       IsNewLOB bit,
                                       IsFileStream bit,
                                       IsColumnStore bit,
                                       IsComputed bit,
                                       IsTimestamp bit,
                                       OnReadOnlyFileGroup bit,
                                       ResumableIndexOperation bit,
                                       StatisticsID int,
                                       StatisticsName nvarchar(max),
                                       [NoRecompute] bit,
                                       IsIncremental bit,
                                       PartitionID bigint,
                                       PartitionNumber int,
                                       PartitionCount int,
                                       StartPosition int,
                                       [Order] int,
                                       Selected bit,
                                       Completed bit,
                                       PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @SelectedIndexes TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  IndexName nvarchar(max),
                                  StartPosition int,
                                  Selected bit)

  DECLARE @Actions TABLE ([Action] nvarchar(max))

  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')

  DECLARE @ActionsPreferred TABLE (FragmentationGroup nvarchar(max),
                                   [Priority] int,
                                   [Action] nvarchar(max))

  DECLARE @CurrentActionsAllowed TABLE ([Action] nvarchar(max))

  DECLARE @CurrentAlterIndexWithClauseArguments TABLE (ID int IDENTITY,
                                                       Argument nvarchar(max),
                                                       Added bit DEFAULT 0)

  DECLARE @CurrentAlterIndexArgumentID int
  DECLARE @CurrentAlterIndexArgument nvarchar(max)
  DECLARE @CurrentAlterIndexWithClause nvarchar(max)

  DECLARE @CurrentUpdateStatisticsWithClauseArguments TABLE (ID int IDENTITY,
                                                             Argument nvarchar(max),
                                                             Added bit DEFAULT 0)

  DECLARE @CurrentUpdateStatisticsArgumentID int
  DECLARE @CurrentUpdateStatisticsArgument nvarchar(max)
  DECLARE @CurrentUpdateStatisticsWithClause nvarchar(max)

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLow = ' + ISNULL('''' + REPLACE(@FragmentationLow,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationMedium = ' + ISNULL('''' + REPLACE(@FragmentationMedium,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationHigh = ' + ISNULL('''' + REPLACE(@FragmentationHigh,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
  SET @Parameters += ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
  SET @Parameters += ', @MinNumberOfPages = ' + ISNULL(CAST(@MinNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @MaxNumberOfPages = ' + ISNULL(CAST(@MaxNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @SortInTempdb = ' + ISNULL('''' + REPLACE(@SortInTempdb,'''','''''') + '''','NULL')
  SET @Parameters += ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @Parameters += ', @FillFactor = ' + ISNULL(CAST(@FillFactor AS nvarchar),'NULL')
  SET @Parameters += ', @PadIndex = ' + ISNULL('''' + REPLACE(@PadIndex,'''','''''') + '''','NULL')
  SET @Parameters += ', @LOBCompaction = ' + ISNULL('''' + REPLACE(@LOBCompaction,'''','''''') + '''','NULL')
  SET @Parameters += ', @UpdateStatistics = ' + ISNULL('''' + REPLACE(@UpdateStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @OnlyModifiedStatistics = ' + ISNULL('''' + REPLACE(@OnlyModifiedStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @StatisticsModificationLevel = ' + ISNULL(CAST(@StatisticsModificationLevel AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsSample = ' + ISNULL(CAST(@StatisticsSample AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsResample = ' + ISNULL('''' + REPLACE(@StatisticsResample,'''','''''') + '''','NULL')
  SET @Parameters += ', @PartitionLevel = ' + ISNULL('''' + REPLACE(@PartitionLevel,'''','''''') + '''','NULL')
  SET @Parameters += ', @MSShippedObjects = ' + ISNULL('''' + REPLACE(@MSShippedObjects,'''','''''') + '''','NULL')
  SET @Parameters += ', @Indexes = ' + ISNULL('''' + REPLACE(@Indexes,'''','''''') + '''','NULL')
  SET @Parameters += ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @Parameters += ', @Delay = ' + ISNULL(CAST(@Delay AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityMaxDuration = ' + ISNULL(CAST(@WaitAtLowPriorityMaxDuration AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityAbortAfterWait = ' + ISNULL('''' + REPLACE(@WaitAtLowPriorityAbortAfterWait,'''','''''') + '''','NULL')
  SET @Parameters += ', @Resumable = ' + ISNULL('''' + REPLACE(@Resumable,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @Parameters += ', @LockMessageSeverity = ' + ISNULL(CAST(@LockMessageSeverity AS nvarchar),'NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExecuteAsUser = ' + ISNULL('''' + REPLACE(@ExecuteAsUser,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

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

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

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

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Select indexes                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Indexes = REPLACE(@Indexes, CHAR(10), '')
  SET @Indexes = REPLACE(@Indexes, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Indexes = LTRIM(RTRIM(@Indexes));

  WITH Indexes1 (StartPosition, EndPosition, IndexItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) - 1) AS IndexItem
  WHERE @Indexes IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) - EndPosition - 1) AS IndexItem
  FROM Indexes1
  WHERE EndPosition < LEN(@Indexes) + 1
  ),
  Indexes2 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem LIKE '-%' THEN RIGHT(IndexItem,LEN(IndexItem) - 1) ELSE IndexItem END AS IndexItem,
         StartPosition,
         CASE WHEN IndexItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Indexes1
  ),
  Indexes3 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem = 'ALL_INDEXES' THEN '%.%.%.%' ELSE IndexItem END AS IndexItem,
         StartPosition,
         Selected
  FROM Indexes2
  ),
  Indexes4 (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,3) ELSE PARSENAME(IndexItem,4) END AS DatabaseName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,2) ELSE PARSENAME(IndexItem,3) END AS SchemaName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,1) ELSE PARSENAME(IndexItem,2) END AS ObjectName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN '%' ELSE PARSENAME(IndexItem,1) END AS IndexName,
         StartPosition,
         Selected
  FROM Indexes3
  )
  INSERT INTO @SelectedIndexes (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected
  FROM Indexes4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select actions                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @FragmentationLow = REPLACE(@FragmentationLow, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationLow (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) - 1) AS [Action]
  WHERE @FragmentationLow IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationLow
  WHERE EndPosition < LEN(@FragmentationLow) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Low' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationLow
  OPTION (MAXRECURSION 0)

  SET @FragmentationMedium = REPLACE(@FragmentationMedium, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationMedium (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) - 1) AS [Action]
  WHERE @FragmentationMedium IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationMedium
  WHERE EndPosition < LEN(@FragmentationMedium) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Medium' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationMedium
  OPTION (MAXRECURSION 0)

  SET @FragmentationHigh = REPLACE(@FragmentationHigh, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationHigh (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) - 1) AS [Action]
  WHERE @FragmentationHigh IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) - EndPosition - 1) AS [Action]
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
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'High' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'High' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 1
  END

  IF @FragmentationLevel1 >= @FragmentationLevel2
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 1
  END

  IF @FragmentationLevel2 <= @FragmentationLevel1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @MinNumberOfPages < 0 OR @MinNumberOfPages IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxNumberOfPages < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @SortInTempdb NOT IN('Y','N') OR @SortInTempdb IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @SortInTempdb is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxDOP < 0 OR @MaxDOP > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FillFactor <= 0 OR @FillFactor > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FillFactor is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @PadIndex NOT IN('Y','N')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PadIndex is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LOBCompaction NOT IN('Y','N') OR @LOBCompaction IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LOBCompaction is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @UpdateStatistics NOT IN('ALL','COLUMNS','INDEX')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @UpdateStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics NOT IN('Y','N') OR @OnlyModifiedStatistics IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @OnlyModifiedStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsModificationLevel <= 0 OR @StatisticsModificationLevel > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsModificationLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics = 'Y' AND @StatisticsModificationLevel IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @OnlyModifiedStatistics and @StatisticsModificationLevel.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsSample <= 0 OR @StatisticsSample  > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsSample is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsResample NOT IN('Y','N') OR @StatisticsResample IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 1
  END

  IF @StatisticsResample = 'Y' AND @StatisticsSample IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @PartitionLevel NOT IN('Y','N') OR @PartitionLevel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PartitionLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MSShippedObjects NOT IN('Y','N') OR @MSShippedObjects IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MSShippedObjects is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedIndexes WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL OR IndexName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 1
  END

  IF @Indexes IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedIndexes)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeLimit < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeLimit is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Delay < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Delay is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityMaxDuration < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityMaxDuration IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityAbortAfterWait NOT IN('NONE','SELF','BLOCKERS')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF (@WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @WaitAtLowPriorityMaxDuration IS NULL) OR (@WaitAtLowPriorityAbortAfterWait IS NULL AND @WaitAtLowPriorityMaxDuration IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @WaitAtLowPriorityMaxDuration and @WaitAtLowPriorityAbortAfterWait can only be used together.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Resumable NOT IN('Y','N') OR @Resumable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 1
  END

  IF @Resumable = 'Y' AND NOT (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5, 8))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 2
  END

  IF @Resumable = 'Y' AND @SortInTempdb = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Resumable and @SortInTempdb.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockTimeout < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockTimeout is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockMessageSeverity NOT IN(10, 16)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @Indexes parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Should statistics be updated on the partition level?                                       //--
  ----------------------------------------------------------------------------------------------------

  SET @PartitionLevelStatistics = CASE WHEN @PartitionLevel = 'Y' AND ((@Version >= 12.05 AND @Version < 13) OR @Version >= 13.04422 OR SERVERPROPERTY('EngineEdition') IN (5,8)) THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
      BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    IF @ExecuteAsUser IS NOT NULL
    BEGIN
      SET @CurrentCommand = ''
      SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.database_principals database_principals WHERE database_principals.[name] = @ParamExecuteAsUser) BEGIN SET @ParamExecuteAsUserExists = 1 END ELSE BEGIN SET @ParamExecuteAsUserExists = 0 END'

      EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamExecuteAsUser sysname, @ParamExecuteAsUserExists bit OUTPUT', @ParamExecuteAsUser = @ExecuteAsUser, @ParamExecuteAsUserExists = @CurrentExecuteAsUserExists OUTPUT
    END

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name]
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentExecuteAsUserExists = 0
    BEGIN
      SET @DatabaseMessage = 'The user ' + QUOTENAME(@ExecuteAsUser) + ' does not exist in the database ' + QUOTENAME(@CurrentDatabaseName) + '.'
      RAISERROR('%s',16,1,@DatabaseMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') = 'READ_WRITE'
    AND (@CurrentExecuteAsUserExists = 1 OR @CurrentExecuteAsUserExists IS NULL)
    BEGIN

      -- Select indexes in the current database
      IF (EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IS NOT NULL) AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'
                              + ' SELECT SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, NoRecompute, IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed'
                              + ' FROM ('

        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', indexes.index_id AS IndexID'
                                                    + ', indexes.[name] AS IndexName'
                                                    + ', indexes.[type] AS IndexType'
                                                    + ', indexes.allow_page_locks AS AllowPageLocks'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id WHERE columns.[object_id] = objects.object_id AND types.name IN(''image'',''text'',''ntext'')) THEN 1 ELSE 0 END AS IsImageText'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE columns.[object_id] = objects.object_id AND (types.name IN(''xml'') OR (types.name IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1'
                                                    + ' WHEN indexes.[type] = 2 AND EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND (types.[name] IN(''xml'') OR (types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1 ELSE 0 END AS IsNewLOB'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns WHERE columns.[object_id] = objects.object_id  AND columns.is_filestream = 1) THEN 1 ELSE 0 END AS IsFileStream'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = objects.object_id AND [type] IN(5,6)) THEN 1 ELSE 0 END AS IsColumnStore'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.object_id = columns.object_id AND index_columns.column_id = columns.column_id WHERE (index_columns.key_ordinal > 0 OR index_columns.partition_ordinal > 0) AND columns.is_computed = 1 AND index_columns.object_id = indexes.object_id AND index_columns.index_id = indexes.index_id) THEN 1 ELSE 0 END AS IsComputed'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.system_type_id WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND types.[name] = ''timestamp'') THEN 1 ELSE 0 END AS IsTimestamp'

                                                    + ', CASE WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.destination_data_spaces destination_data_spaces ON indexes.data_space_id = destination_data_spaces.partition_scheme_id INNER JOIN sys.filegroups filegroups ON destination_data_spaces.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes2.[object_id] = indexes.[object_id] AND indexes2.[index_id] = indexes.index_id' + CASE WHEN @PartitionLevel = 'Y' THEN ' AND destination_data_spaces.destination_id = partitions.partition_number' ELSE '' END + ') THEN 1'
                                                    + ' WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.filegroups filegroups ON indexes.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = indexes2.[object_id] AND indexes.[index_id] = indexes2.index_id) THEN 1'
                                                    + ' WHEN indexes.[type] = 1 AND EXISTS (SELECT * FROM sys.tables tables INNER JOIN sys.filegroups filegroups ON tables.lob_data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND tables.[object_id] = objects.[object_id]) THEN 1 ELSE 0 END AS OnReadOnlyFileGroup'

                                                    + ', ' + CASE WHEN @Version >= 14 THEN 'CASE WHEN EXISTS(SELECT * FROM sys.index_resumable_operations index_resumable_operations WHERE state_desc = ''PAUSED'' AND index_resumable_operations.object_id = indexes.object_id AND index_resumable_operations.index_id = indexes.index_id AND (index_resumable_operations.partition_number = partitions.partition_number OR index_resumable_operations.partition_number IS NULL)) THEN 1 ELSE 0 END' ELSE '0' END + ' AS ResumableIndexOperation'

                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_id AS PartitionID' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionID' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_number AS PartitionNumber' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionNumber' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'IndexPartitions.partition_count AS PartitionCount' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionCount' END
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.indexes indexes'
                                                    + ' INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'
                                                    + ' LEFT OUTER JOIN sys.stats stats ON indexes.[object_id] = stats.[object_id] AND indexes.[index_id] = stats.[stats_id]'
          IF @PartitionLevel = 'Y'
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' LEFT OUTER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id'
                                                      + ' LEFT OUTER JOIN (SELECT partitions.[object_id], partitions.index_id, COUNT(DISTINCT partitions.partition_number) AS partition_count FROM sys.partitions partitions GROUP BY partitions.[object_id], partitions.index_id) IndexPartitions ON partitions.[object_id] = IndexPartitions.[object_id] AND partitions.[index_id] = IndexPartitions.[index_id]'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND indexes.[type] IN(1,2,3,4,5,6,7)'
                                                    + ' AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0'
        END

        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL'
        BEGIN
          SET @CurrentCommand = @CurrentCommand + ' UNION '
        END

        IF @UpdateStatistics IN('ALL','COLUMNS')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', NULL AS IndexID, NULL AS IndexName'
                                                    + ', NULL AS IndexType'
                                                    + ', NULL AS AllowPageLocks'
                                                    + ', NULL AS IsImageText'
                                                    + ', NULL AS IsNewLOB'
                                                    + ', NULL AS IsFileStream'
                                                    + ', NULL AS IsColumnStore'
                                                    + ', NULL AS IsComputed'
                                                    + ', NULL AS IsTimestamp'
                                                    + ', NULL AS OnReadOnlyFileGroup'
                                                    + ', NULL AS ResumableIndexOperation'
                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', NULL AS PartitionID'
                                                    + ', ' + CASE WHEN @PartitionLevelStatistics = 1 THEN 'dm_db_incremental_stats_properties.partition_number' ELSE 'NULL' END + ' AS PartitionNumber'
                                                    + ', NULL AS PartitionCount'
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.stats stats'
                                                    + ' INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'

          IF @PartitionLevelStatistics = 1
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' OUTER APPLY sys.dm_db_incremental_stats_properties(stats.object_id, stats.stats_id) dm_db_incremental_stats_properties'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND NOT EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = stats.[object_id] AND indexes.index_id = stats.stats_id)'
        END

        SET @CurrentCommand = @CurrentCommand + ') IndexesStatistics'

        INSERT INTO @tmpIndexesStatistics (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, [NoRecompute], IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand
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

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.StartPosition = SelectedIndexes2.StartPosition
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN (SELECT tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName, MIN(SelectedIndexes.StartPosition) AS StartPosition
                    FROM @tmpIndexesStatistics tmpIndexesStatistics
                    INNER JOIN @SelectedIndexes SelectedIndexes
                    ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
                    WHERE SelectedIndexes.Selected = 1
                    GROUP BY tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName) SelectedIndexes2
        ON tmpIndexesStatistics.SchemaName = SelectedIndexes2.SchemaName
        AND tmpIndexesStatistics.ObjectName = SelectedIndexes2.ObjectName
        AND (tmpIndexesStatistics.IndexName = SelectedIndexes2.IndexName OR tmpIndexesStatistics.IndexName IS NULL)
        AND (tmpIndexesStatistics.StatisticsName = SelectedIndexes2.StatisticsName OR tmpIndexesStatistics.StatisticsName IS NULL)
      END;

      WITH tmpIndexesStatistics AS (
      SELECT SchemaName, ObjectName, [Order], ROW_NUMBER() OVER (ORDER BY ISNULL(ResumableIndexOperation,0) DESC, StartPosition ASC, SchemaName ASC, ObjectName ASC, CASE WHEN IndexType IS NULL THEN 1 ELSE 0 END ASC, IndexType ASC, IndexName ASC, StatisticsName ASC, PartitionNumber ASC) AS RowNumber
      FROM @tmpIndexesStatistics tmpIndexesStatistics
      WHERE Selected = 1
      )
      UPDATE tmpIndexesStatistics
      SET [Order] = RowNumber

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following objects in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + '.' + QUOTENAME(IndexName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName NOT LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName AND IndexName = SelectedIndexes.IndexName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following indexes in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SELECT TOP 1 @CurrentIxID = ID,
                     @CurrentIxOrder = [Order],
                     @CurrentSchemaID = SchemaID,
                     @CurrentSchemaName = SchemaName,
                     @CurrentObjectID = ObjectID,
                     @CurrentObjectName = ObjectName,
                     @CurrentObjectType = ObjectType,
                     @CurrentIsMemoryOptimized = IsMemoryOptimized,
                     @CurrentIndexID = IndexID,
                     @CurrentIndexName = IndexName,
                     @CurrentIndexType = IndexType,
                     @CurrentAllowPageLocks = AllowPageLocks,
                     @CurrentIsImageText = IsImageText,
                     @CurrentIsNewLOB = IsNewLOB,
                     @CurrentIsFileStream = IsFileStream,
                     @CurrentIsColumnStore = IsColumnStore,
                     @CurrentIsComputed = IsComputed,
                     @CurrentIsTimestamp = IsTimestamp,
                     @CurrentOnReadOnlyFileGroup = OnReadOnlyFileGroup,
                     @CurrentResumableIndexOperation = ResumableIndexOperation,
                     @CurrentStatisticsID = StatisticsID,
                     @CurrentStatisticsName = StatisticsName,
                     @CurrentNoRecompute = [NoRecompute],
                     @CurrentIsIncremental = IsIncremental,
                     @CurrentPartitionID = PartitionID,
                     @CurrentPartitionNumber = PartitionNumber,
                     @CurrentPartitionCount = PartitionCount
        FROM @tmpIndexesStatistics
        WHERE Selected = 1
        AND Completed = 0
        ORDER BY [Order] ASC

        IF @@ROWCOUNT = 0
        BEGIN
          BREAK
        END

        -- Is the index a partition?
        IF @CurrentPartitionNumber IS NULL OR @CurrentPartitionCount = 1 BEGIN SET @CurrentIsPartition = 0 END ELSE BEGIN SET @CurrentIsPartition = 1 END

        -- Does the index exist?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @CurrentIsPartition = 0 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType) BEGIN SET @ParamIndexExists = 1 END'
          IF @CurrentIsPartition = 1 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] INNER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType AND partitions.partition_id = @ParamPartitionID AND partitions.partition_number = @ParamPartitionNumber) BEGIN SET @ParamIndexExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamIndexID int, @ParamIndexName sysname, @ParamIndexType int, @ParamPartitionID bigint, @ParamPartitionNumber int, @ParamIndexExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamIndexID = @CurrentIndexID, @ParamIndexName = @CurrentIndexName, @ParamIndexType = @CurrentIndexType, @ParamPartitionID = @CurrentPartitionID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamIndexExists = @CurrentIndexExists OUTPUT

            IF @CurrentIndexExists IS NULL
            BEGIN
              SET @CurrentIndexExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Does the statistics exist?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.stats stats INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND stats.stats_id = @ParamStatisticsID AND stats.[name] = @ParamStatisticsName) BEGIN SET @ParamStatisticsExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamStatisticsID int, @ParamStatisticsName sysname, @ParamStatisticsExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsName = @CurrentStatisticsName, @ParamStatisticsExists = @CurrentStatisticsExists OUTPUT

            IF @CurrentStatisticsExists IS NULL
            BEGIN
              SET @CurrentStatisticsExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the statistics exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Has the data in the statistics been modified since the statistics was last updated?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_incremental_stats_properties (@ParamObjectID, @ParamStatisticsID) WHERE partition_number = @ParamPartitionNumber'
          END
          ELSE
          IF (@Version >= 10.504000 AND @Version < 11) OR @Version >= 11.03000
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_stats_properties (@ParamObjectID, @ParamStatisticsID)'
          END
          ELSE
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = rowcnt, @ParamModificationCounter = rowmodctr FROM sys.sysindexes sysindexes WHERE sysindexes.[id] = @ParamObjectID AND sysindexes.[indid] = @ParamStatisticsID'
          END

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamPartitionNumber int, @ParamRowCount bigint OUTPUT, @ParamModificationCounter bigint OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamRowCount = @CurrentRowCount OUTPUT, @ParamModificationCounter = @CurrentModificationCounter OUTPUT

            IF @CurrentRowCount IS NULL SET @CurrentRowCount = 0
            IF @CurrentModificationCounter IS NULL SET @CurrentModificationCounter = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The rows and modification_counter could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Is the index fragmented?
        IF @CurrentIndexID IS NOT NULL
        AND @CurrentOnReadOnlyFileGroup = 0
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3) OR @MinNumberOfPages > 0 OR @MaxNumberOfPages IS NOT NULL)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'SELECT @ParamFragmentationLevel = MAX(avg_fragmentation_in_percent), @ParamPageCount = SUM(page_count) FROM sys.dm_db_index_physical_stats(DB_ID(@ParamDatabaseName), @ParamObjectID, @ParamIndexID, @ParamPartitionNumber, ''LIMITED'') WHERE alloc_unit_type_desc = ''IN_ROW_DATA'' AND index_level = 0'

          BEGIN TRY
            EXECUTE sp_executesql @stmt = @CurrentCommand, @params = N'@ParamDatabaseName nvarchar(max), @ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamFragmentationLevel float OUTPUT, @ParamPageCount bigint OUTPUT', @ParamDatabaseName = @CurrentDatabaseName, @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamFragmentationLevel = @CurrentFragmentationLevel OUTPUT, @ParamPageCount = @CurrentPageCount OUTPUT
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The page_count and avg_fragmentation_in_percent could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
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
          AND SERVERPROPERTY('EngineEdition') IN (3,5,8)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_ONLINE')
          END
        END

        -- Decide action
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (@CurrentPageCount >= @MinNumberOfPages OR @MinNumberOfPages = 0)
        AND (@CurrentPageCount <= @MaxNumberOfPages OR @MaxNumberOfPages IS NULL)
        AND @CurrentResumableIndexOperation = 0
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

        IF @CurrentResumableIndexOperation = 1
        BEGIN
          SET @CurrentAction = 'INDEX_REBUILD_ONLINE'
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
        AND ((@OnlyModifiedStatistics = 'N' AND @StatisticsModificationLevel IS NULL) OR (@OnlyModifiedStatistics = 'Y' AND @CurrentModificationCounter > 0) OR ((@CurrentModificationCounter * 1. / NULLIF(@CurrentRowCount,0)) * 100 >= @StatisticsModificationLevel) OR (@StatisticsModificationLevel IS NOT NULL AND @CurrentModificationCounter > 0 AND (@CurrentModificationCounter >= SQRT(@CurrentRowCount * 1000))) OR (@CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8))))
        AND ((@CurrentIsPartition = 0 AND (@CurrentAction NOT IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') OR @CurrentAction IS NULL)) OR (@CurrentIsPartition = 1 AND (@CurrentPartitionNumber = @CurrentPartitionCount OR (@PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1))))
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
        IF @CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND (@CurrentStatisticsSample <> 100 OR @CurrentStatisticsSample IS NULL)
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Incremental statistics only supports RESAMPLE
        IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Create index comment
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'ImageText: ' + CASE WHEN @CurrentIsImageText = 1 THEN 'Yes' WHEN @CurrentIsImageText = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'NewLOB: ' + CASE WHEN @CurrentIsNewLOB = 1 THEN 'Yes' WHEN @CurrentIsNewLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'FileStream: ' + CASE WHEN @CurrentIsFileStream = 1 THEN 'Yes' WHEN @CurrentIsFileStream = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 11 SET @CurrentComment += 'ColumnStore: ' + CASE WHEN @CurrentIsColumnStore = 1 THEN 'Yes' WHEN @CurrentIsColumnStore = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Computed: ' + CASE WHEN @CurrentIsComputed = 1 THEN 'Yes' WHEN @CurrentIsComputed = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Timestamp: ' + CASE WHEN @CurrentIsTimestamp = 1 THEN 'Yes' WHEN @CurrentIsTimestamp = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'AllowPageLocks: ' + CASE WHEN @CurrentAllowPageLocks = 1 THEN 'Yes' WHEN @CurrentAllowPageLocks = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'PageCount: ' + ISNULL(CAST(@CurrentPageCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'Fragmentation: ' + ISNULL(CAST(@CurrentFragmentationLevel AS nvarchar),'N/A')
        END

        IF @CurrentIndexID IS NOT NULL AND (@CurrentPageCount IS NOT NULL OR @CurrentFragmentationLevel IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentPageCount AS nvarchar) AS [PageCount],
                                                 CAST(@CurrentFragmentationLevel AS nvarchar) AS Fragmentation
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentIndexID IS NOT NULL AND @CurrentAction IS NOT NULL AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'ALTER_INDEX'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName)
          IF @CurrentResumableIndexOperation = 1 SET @CurrentCommand += ' RESUME'
          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REBUILD'
          IF @CurrentAction IN('INDEX_REORGANIZE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REORGANIZE'
          IF @CurrentIsPartition = 1 AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'Y' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = ON'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'N' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = OFF'
          END

          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = ON' + CASE WHEN @WaitAtLowPriorityMaxDuration IS NOT NULL THEN ' (WAIT_AT_LOW_PRIORITY (MAX_DURATION = ' + CAST(@WaitAtLowPriorityMaxDuration AS nvarchar) + ', ABORT_AFTER_WAIT = ' + UPPER(@WaitAtLowPriorityAbortAfterWait) + '))' ELSE '' END
          END

          IF @CurrentAction = 'INDEX_REBUILD_OFFLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = OFF'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentMaxDOP IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @FillFactor IS NOT NULL AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'FILLFACTOR = ' + CAST(@FillFactor AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @PadIndex = 'Y' AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'PAD_INDEX = ON'
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT CASE WHEN @Resumable = 'Y' AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 THEN 'RESUMABLE = ON' ELSE 'RESUMABLE = OFF' END
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0 AND @Resumable = 'Y'  AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 AND @TimeLimit IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAX_DURATION = ' + CAST(DATEDIFF(MINUTE,SYSDATETIME(),DATEADD(SECOND,@TimeLimit,@StartTime)) AS nvarchar(max))
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'Y'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = ON'
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'N'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = OFF'
          END

          IF EXISTS (SELECT * FROM @CurrentAlterIndexWithClauseArguments)
          BEGIN
            SET @CurrentAlterIndexWithClause = ' WITH ('

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentAlterIndexArgumentID = ID,
                           @CurrentAlterIndexArgument = Argument
              FROM @CurrentAlterIndexWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentAlterIndexWithClause += @CurrentAlterIndexArgument + ', '

              UPDATE @CurrentAlterIndexWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentAlterIndexArgumentID
            END

            SET @CurrentAlterIndexWithClause = RTRIM(@CurrentAlterIndexWithClause)

            SET @CurrentAlterIndexWithClause = LEFT(@CurrentAlterIndexWithClause,LEN(@CurrentAlterIndexWithClause) - 1)

            SET @CurrentAlterIndexWithClause = @CurrentAlterIndexWithClause + ')'
          END

          IF @CurrentAlterIndexWithClause IS NOT NULL SET @CurrentCommand += @CurrentAlterIndexWithClause

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @PartitionNumber = @CurrentPartitionNumber, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          IF @Delay > 0
          BEGIN
            SET @CurrentDelay = DATEADD(ss,@Delay,'1900-01-01')
            WAITFOR DELAY @CurrentDelay
          END
        END

        SET @CurrentMaxDOP = @MaxDOP

        -- Create statistics comment
        IF @CurrentStatisticsID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexID IS NOT NULL THEN 'Index' ELSE 'Column' END + ', '
          IF @CurrentIndexID IS NOT NULL SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'Incremental: ' + CASE WHEN @CurrentIsIncremental = 1 THEN 'Y' WHEN @CurrentIsIncremental = 0 THEN 'N' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'RowCount: ' + ISNULL(CAST(@CurrentRowCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'ModificationCounter: ' + ISNULL(CAST(@CurrentModificationCounter AS nvarchar),'N/A')
        END

        IF @CurrentStatisticsID IS NOT NULL AND (@CurrentRowCount IS NOT NULL OR @CurrentModificationCounter IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentRowCount AS nvarchar) AS [RowCount],
                                                 CAST(@CurrentModificationCounter AS nvarchar) AS ModificationCounter
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentStatisticsID IS NOT NULL AND @CurrentUpdateStatistics = 'Y' AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'UPDATE_STATISTICS'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'UPDATE STATISTICS ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentStatisticsName)

          IF @CurrentMaxDOP IS NOT NULL AND ((@Version >= 12.06024 AND @Version < 13) OR (@Version >= 13.05026 AND @Version < 14) OR @Version >= 14.030154)
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentStatisticsSample = 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'FULLSCAN'
          END

          IF @CurrentStatisticsSample IS NOT NULL AND @CurrentStatisticsSample <> 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'SAMPLE ' + CAST(@CurrentStatisticsSample AS nvarchar) + ' PERCENT'
          END

          IF @CurrentStatisticsResample = 'Y'
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'RESAMPLE'
          END

          IF @CurrentNoRecompute = 1
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'NORECOMPUTE'
          END

          IF EXISTS (SELECT * FROM @CurrentUpdateStatisticsWithClauseArguments)
          BEGIN
            SET @CurrentUpdateStatisticsWithClause = ' WITH'

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentUpdateStatisticsArgumentID = ID,
                           @CurrentUpdateStatisticsArgument = Argument
              FROM @CurrentUpdateStatisticsWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentUpdateStatisticsWithClause = @CurrentUpdateStatisticsWithClause + ' ' + @CurrentUpdateStatisticsArgument + ','

              UPDATE @CurrentUpdateStatisticsWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentUpdateStatisticsArgumentID
            END

            SET @CurrentUpdateStatisticsWithClause = LEFT(@CurrentUpdateStatisticsWithClause,LEN(@CurrentUpdateStatisticsWithClause) - 1)
          END

          IF @CurrentUpdateStatisticsWithClause IS NOT NULL SET @CurrentCommand += @CurrentUpdateStatisticsWithClause

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1 AND @CurrentPartitionNumber IS NOT NULL SET @CurrentCommand += ' ON PARTITIONS(' + CAST(@CurrentPartitionNumber AS nvarchar(max)) + ')'

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @StatisticsName = @CurrentStatisticsName, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
        END

        NoAction:

        -- Update that the index or statistics is completed
        UPDATE @tmpIndexesStatistics
        SET Completed = 1
        WHERE Selected = 1
        AND Completed = 0
        AND [Order] = @CurrentIxOrder
        AND ID = @CurrentIxID

        -- Clear variables
        SET @CurrentDatabaseContext = NULL

        SET @CurrentCommand = NULL
        SET @CurrentCommandOutput = NULL
        SET @CurrentCommandType = NULL
        SET @CurrentComment = NULL
        SET @CurrentExtendedInfo = NULL

        SET @CurrentIxID = NULL
        SET @CurrentIxOrder = NULL
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
        SET @CurrentIsComputed = NULL
        SET @CurrentIsTimestamp = NULL
        SET @CurrentAllowPageLocks = NULL
        SET @CurrentNoRecompute = NULL
        SET @CurrentIsIncremental = NULL
        SET @CurrentRowCount = NULL
        SET @CurrentModificationCounter = NULL
        SET @CurrentOnReadOnlyFileGroup = NULL
        SET @CurrentResumableIndexOperation = NULL
        SET @CurrentFragmentationLevel = NULL
        SET @CurrentPageCount = NULL
        SET @CurrentFragmentationGroup = NULL
        SET @CurrentAction = NULL
        SET @CurrentMaxDOP = NULL
        SET @CurrentUpdateStatistics = NULL
        SET @CurrentStatisticsSample = NULL
        SET @CurrentStatisticsResample = NULL
        SET @CurrentAlterIndexArgumentID = NULL
        SET @CurrentAlterIndexArgument = NULL
        SET @CurrentAlterIndexWithClause = NULL
        SET @CurrentUpdateStatisticsArgumentID = NULL
        SET @CurrentUpdateStatisticsArgument = NULL
        SET @CurrentUpdateStatisticsWithClause = NULL

        DELETE FROM @CurrentActionsAllowed
        DELETE FROM @CurrentAlterIndexWithClauseArguments
        DELETE FROM @CurrentUpdateStatisticsWithClauseArguments

      END

    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @Error = @@ERROR
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentExecuteAsUserExists = NULL
    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL

    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentDatabaseMirroringRole = NULL

    SET @CurrentCommand = NULL

    DELETE FROM @tmpIndexesStatistics

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO
IF (SELECT [Value] FROM #Config WHERE Name = 'CreateJobs') = 'Y' AND SERVERPROPERTY('EngineEdition') NOT IN(4, 5) AND (IS_SRVROLEMEMBER('sysadmin') = 1 OR (DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa')) AND (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
BEGIN

  DECLARE @BackupDirectory nvarchar(max)
  DECLARE @CleanupTime int
  DECLARE @OutputFileDirectory nvarchar(max)
  DECLARE @LogToTable nvarchar(max)
  DECLARE @DatabaseName nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)
  DECLARE @DirectorySeparator nvarchar(max)
  DECLARE @LogDirectory nvarchar(max)

  DECLARE @TokenServer nvarchar(max)
  DECLARE @TokenJobID nvarchar(max)
  DECLARE @TokenJobName nvarchar(max)
  DECLARE @TokenStepID nvarchar(max)
  DECLARE @TokenStepName nvarchar(max)
  DECLARE @TokenDate nvarchar(max)
  DECLARE @TokenTime nvarchar(max)
  DECLARE @TokenLogDirectory nvarchar(max)

  DECLARE @JobDescription nvarchar(max)
  DECLARE @JobCategory nvarchar(max)
  DECLARE @JobOwner nvarchar(max)

  DECLARE @Jobs TABLE (JobID int IDENTITY,
                       [Name] nvarchar(max),
                       CommandTSQL nvarchar(max),
                       CommandCmdExec nvarchar(max),
                       DatabaseName varchar(max),
                       OutputFileNamePart01 nvarchar(max),
                       OutputFileNamePart02 nvarchar(max),
                       Selected bit DEFAULT 0,
                       Completed bit DEFAULT 0)

  DECLARE @CurrentJobID int
  DECLARE @CurrentJobName nvarchar(max)
  DECLARE @CurrentCommandTSQL nvarchar(max)
  DECLARE @CurrentCommandCmdExec nvarchar(max)
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentOutputFileNamePart01 nvarchar(max)
  DECLARE @CurrentOutputFileNamePart02 nvarchar(max)

  DECLARE @CurrentJobStepCommand nvarchar(max)
  DECLARE @CurrentJobStepSubSystem nvarchar(max)
  DECLARE @CurrentJobStepDatabaseName nvarchar(max)
  DECLARE @CurrentOutputFileName nvarchar(max)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  SELECT @DirectorySeparator = CASE
  WHEN @HostPlatform = 'Windows' THEN '\'
  WHEN @HostPlatform = 'Linux' THEN '/'
  END

  SET @TokenServer = '$' + '(ESCAPE_SQUOTE(SRVR))'
  SET @TokenJobID = '$' + '(ESCAPE_SQUOTE(JOBID))'
  SET @TokenStepID = '$' + '(ESCAPE_SQUOTE(STEPID))'
  SET @TokenDate = '$' + '(ESCAPE_SQUOTE(DATE))'
  SET @TokenTime = '$' + '(ESCAPE_SQUOTE(TIME))'

  IF @Version >= 13
  BEGIN
    SET @TokenJobName = '$' + '(ESCAPE_SQUOTE(JOBNAME))'
    SET @TokenStepName = '$' + '(ESCAPE_SQUOTE(STEPNAME))'
  END

  IF @Version >= 12 AND @HostPlatform = 'Windows'
  BEGIN
    SET @TokenLogDirectory = '$' + '(ESCAPE_SQUOTE(SQLLOGDIR))'
  END

  SELECT @BackupDirectory = Value
  FROM #Config
  WHERE [Name] = 'BackupDirectory'

  IF @HostPlatform = 'Windows'
  BEGIN
    SELECT @CleanupTime = Value
    FROM #Config
    WHERE [Name] = 'CleanupTime'
  END

  SELECT @OutputFileDirectory = Value
  FROM #Config
  WHERE [Name] = 'OutputFileDirectory'

  SELECT @LogToTable = Value
  FROM #Config
  WHERE [Name] = 'LogToTable'

  SELECT @DatabaseName = Value
  FROM #Config
  WHERE [Name] = 'DatabaseName'

  IF @Version >= 11
  BEGIN
    SELECT @LogDirectory = [path]
    FROM sys.dm_os_server_diagnostics_log_configurations
  END
  ELSE
  BEGIN
    SELECT @LogDirectory = LEFT(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max)),LEN(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max))) - CHARINDEX('\',REVERSE(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max)))))
  END

  IF @OutputFileDirectory IS NOT NULL AND RIGHT(@OutputFileDirectory,1) = @DirectorySeparator
  BEGIN
    SET @OutputFileDirectory = LEFT(@OutputFileDirectory, LEN(@OutputFileDirectory) - 1)
  END

  IF @LogDirectory IS NOT NULL AND RIGHT(@LogDirectory,1) = @DirectorySeparator
  BEGIN
    SET @LogDirectory = LEFT(@LogDirectory, LEN(@LogDirectory) - 1)
  END

  SET @JobDescription = 'Source: https://ola.hallengren.com'
  SET @JobCategory = 'Database Maintenance'

  IF @AmazonRDS = 0
  BEGIN
    SET @JobOwner = SUSER_SNAME(0x01)
  END

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01, OutputFileNamePart02)
  SELECT 'DatabaseBackup - SYSTEM_DATABASES - FULL',
         'EXECUTE [dbo].[DatabaseBackup]' + CHAR(13) + CHAR(10) + '@Databases = ''SYSTEM_DATABASES'',' + CHAR(13) + CHAR(10) + '@Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ',' + CHAR(13) + CHAR(10) + '@BackupType = ''FULL'',' + CHAR(13) + CHAR(10) + '@Verify = ''Y'',' + CHAR(13) + CHAR(10) + '@CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ',' + CHAR(13) + CHAR(10) + '@CheckSum = ''Y'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'DatabaseBackup',
         'FULL'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01, OutputFileNamePart02)
  SELECT 'DatabaseBackup - USER_DATABASES - DIFF',
         'EXECUTE [dbo].[DatabaseBackup]' + CHAR(13) + CHAR(10) + '@Databases = ''USER_DATABASES'',' + CHAR(13) + CHAR(10) + '@Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ',' + CHAR(13) + CHAR(10) + '@BackupType = ''DIFF'',' + CHAR(13) + CHAR(10) + '@Verify = ''Y'',' + CHAR(13) + CHAR(10) + '@CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ',' + CHAR(13) + CHAR(10) + '@CheckSum = ''Y'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
          @DatabaseName,
         'DatabaseBackup',
         'DIFF'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01, OutputFileNamePart02)
  SELECT 'DatabaseBackup - USER_DATABASES - FULL',
         'EXECUTE [dbo].[DatabaseBackup]' + CHAR(13) + CHAR(10) + '@Databases = ''USER_DATABASES'',' + CHAR(13) + CHAR(10) + '@Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ',' + CHAR(13) + CHAR(10) + '@BackupType = ''FULL'',' + CHAR(13) + CHAR(10) + '@Verify = ''Y'',' + CHAR(13) + CHAR(10) + '@CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ',' + CHAR(13) + CHAR(10) + '@CheckSum = ''Y'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'DatabaseBackup',
         'FULL'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01, OutputFileNamePart02)
  SELECT 'DatabaseBackup - USER_DATABASES - LOG',
         'EXECUTE [dbo].[DatabaseBackup]' + CHAR(13) + CHAR(10) + '@Databases = ''USER_DATABASES'',' + CHAR(13) + CHAR(10) + '@Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ',' + CHAR(13) + CHAR(10) + '@BackupType = ''LOG'',' + CHAR(13) + CHAR(10) + '@Verify = ''Y'',' + CHAR(13) + CHAR(10) + '@CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ',' + CHAR(13) + CHAR(10) + '@CheckSum = ''Y'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'DatabaseBackup',
         'LOG'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'DatabaseIntegrityCheck - SYSTEM_DATABASES',
         'EXECUTE [dbo].[DatabaseIntegrityCheck]' + CHAR(13) + CHAR(10) + '@Databases = ''SYSTEM_DATABASES'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'DatabaseIntegrityCheck'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'DatabaseIntegrityCheck - USER_DATABASES',
         'EXECUTE [dbo].[DatabaseIntegrityCheck]' + CHAR(13) + CHAR(10) + '@Databases = ''USER_DATABASES' + CASE WHEN @AmazonRDS = 1 THEN ', -rdsadmin' ELSE '' END + ''',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'DatabaseIntegrityCheck'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'IndexOptimize - USER_DATABASES',
         'EXECUTE [dbo].[IndexOptimize]' + CHAR(13) + CHAR(10) + '@Databases = ''USER_DATABASES'',' + CHAR(13) + CHAR(10) + '@LogToTable = ''' + @LogToTable + '''',
         @DatabaseName,
         'IndexOptimize'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'sp_delete_backuphistory',
         'DECLARE @CleanupDate datetime' + CHAR(13) + CHAR(10) + 'SET @CleanupDate = DATEADD(dd,-30,GETDATE())' + CHAR(13) + CHAR(10) + 'EXECUTE dbo.sp_delete_backuphistory @oldest_date = @CleanupDate',
         'msdb',
         'sp_delete_backuphistory'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'sp_purge_jobhistory',
         'DECLARE @CleanupDate datetime' + CHAR(13) + CHAR(10) + 'SET @CleanupDate = DATEADD(dd,-30,GETDATE())' + CHAR(13) + CHAR(10) + 'EXECUTE dbo.sp_purge_jobhistory @oldest_date = @CleanupDate',
         'msdb',
         'sp_purge_jobhistory'

  INSERT INTO @Jobs ([Name], CommandTSQL, DatabaseName, OutputFileNamePart01)
  SELECT 'CommandLog Cleanup',
         'DELETE FROM [dbo].[CommandLog]' + CHAR(13) + CHAR(10) + 'WHERE StartTime < DATEADD(dd,-30,GETDATE())',
         @DatabaseName,
         'CommandLogCleanup'

  INSERT INTO @Jobs ([Name], CommandCmdExec, OutputFileNamePart01)
  SELECT 'Output File Cleanup',
         'cmd /q /c "For /F "tokens=1 delims=" %v In (''ForFiles /P "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + '" /m *_*_*_*.txt /d -30 2^>^&1'') do if EXIST "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + '"\%v echo del "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + '"\%v& del "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + '"\%v"',
         'OutputFileCleanup'

  IF @AmazonRDS = 1
  BEGIN
   UPDATE @Jobs
   SET Selected = 1
   WHERE [Name] IN('DatabaseIntegrityCheck - USER_DATABASES','IndexOptimize - USER_DATABASES','CommandLog Cleanup')
  END
  ELSE IF SERVERPROPERTY('EngineEdition') = 8
  BEGIN
   UPDATE @Jobs
   SET Selected = 1
   WHERE [Name] IN('DatabaseIntegrityCheck - SYSTEM_DATABASES','DatabaseIntegrityCheck - USER_DATABASES','IndexOptimize - USER_DATABASES','CommandLog Cleanup','sp_delete_backuphistory','sp_purge_jobhistory')
  END
  ELSE IF @HostPlatform = 'Windows'
  BEGIN
   UPDATE @Jobs
   SET Selected = 1
  END
  ELSE IF @HostPlatform = 'Linux'
  BEGIN
   UPDATE @Jobs
   SET Selected = 1
   WHERE CommandTSQL IS NOT NULL
  END

  WHILE EXISTS (SELECT * FROM @Jobs WHERE Completed = 0 AND Selected = 1)
  BEGIN
    SELECT @CurrentJobID = JobID,
           @CurrentJobName = [Name],
           @CurrentCommandTSQL = CommandTSQL,
           @CurrentCommandCmdExec = CommandCmdExec,
           @CurrentDatabaseName = DatabaseName,
           @CurrentOutputFileNamePart01 = OutputFileNamePart01,
           @CurrentOutputFileNamePart02 = OutputFileNamePart02
    FROM @Jobs
    WHERE Completed = 0
    AND Selected = 1
    ORDER BY JobID ASC

    IF @CurrentCommandTSQL IS NOT NULL AND @AmazonRDS = 1
    BEGIN
      SET @CurrentJobStepSubSystem = 'TSQL'
      SET @CurrentJobStepCommand = @CurrentCommandTSQL
      SET @CurrentJobStepDatabaseName = @CurrentDatabaseName
    END
    ELSE IF @CurrentCommandTSQL IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 8
    BEGIN
      SET @CurrentJobStepSubSystem = 'TSQL'
      SET @CurrentJobStepCommand = @CurrentCommandTSQL
      SET @CurrentJobStepDatabaseName = @CurrentDatabaseName
    END
    ELSE IF @CurrentCommandTSQL IS NOT NULL AND @HostPlatform = 'Linux'
    BEGIN
      SET @CurrentJobStepSubSystem = 'TSQL'
      SET @CurrentJobStepCommand = @CurrentCommandTSQL
      SET @CurrentJobStepDatabaseName = @CurrentDatabaseName
    END
    ELSE IF @CurrentCommandTSQL IS NOT NULL AND @HostPlatform = 'Windows' AND @Version >= 11
    BEGIN
      SET @CurrentJobStepSubSystem = 'TSQL'
      SET @CurrentJobStepCommand = @CurrentCommandTSQL
      SET @CurrentJobStepDatabaseName = @CurrentDatabaseName
    END
    ELSE IF @CurrentCommandTSQL IS NOT NULL AND @HostPlatform = 'Windows' AND @Version < 11
    BEGIN
      SET @CurrentJobStepSubSystem = 'CMDEXEC'
      SET @CurrentJobStepCommand = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @CurrentDatabaseName + ' -Q "' + REPLACE(@CurrentCommandTSQL,(CHAR(13) + CHAR(10)),' ') + '" -b'
      SET @CurrentJobStepDatabaseName = NULL
    END
    ELSE IF @CurrentCommandCmdExec IS NOT NULL AND @HostPlatform = 'Windows'
    BEGIN
      SET @CurrentJobStepSubSystem = 'CMDEXEC'
      SET @CurrentJobStepCommand = @CurrentCommandCmdExec
      SET @CurrentJobStepDatabaseName = NULL
    END

    IF @AmazonRDS = 0 AND SERVERPROPERTY('EngineEdition') <> 8
    BEGIN
      SET @CurrentOutputFileName = COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + @DirectorySeparator + ISNULL(CASE WHEN @TokenJobName IS NULL THEN @CurrentOutputFileNamePart01 END + '_','') + ISNULL(CASE WHEN @TokenJobName IS NULL THEN @CurrentOutputFileNamePart02 END + '_','') + ISNULL(@TokenJobName,@TokenJobID) + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
      IF LEN(@CurrentOutputFileName) > 200 SET @CurrentOutputFileName = COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + @DirectorySeparator + ISNULL(CASE WHEN @TokenJobName IS NULL THEN @CurrentOutputFileNamePart01 END + '_','') + ISNULL(@TokenJobName,@TokenJobID) + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
      IF LEN(@CurrentOutputFileName) > 200 SET @CurrentOutputFileName = COALESCE(@OutputFileDirectory,@TokenLogDirectory,@LogDirectory) + @DirectorySeparator + ISNULL(@TokenJobName,@TokenJobID) + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
      IF LEN(@CurrentOutputFileName) > 200 SET @CurrentOutputFileName = NULL
    END

    IF @CurrentJobStepSubSystem IS NOT NULL AND @CurrentJobStepCommand IS NOT NULL AND NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @CurrentJobName)
    BEGIN
      EXECUTE msdb.dbo.sp_add_job @job_name = @CurrentJobName, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
      EXECUTE msdb.dbo.sp_add_jobstep @job_name = @CurrentJobName, @step_name = @CurrentJobName, @subsystem = @CurrentJobStepSubSystem, @command = @CurrentJobStepCommand, @output_file_name = @CurrentOutputFileName, @database_name = @CurrentJobStepDatabaseName
      EXECUTE msdb.dbo.sp_add_jobserver @job_name = @CurrentJobName
    END

    UPDATE Jobs
    SET Completed = 1
    FROM @Jobs Jobs
    WHERE JobID = @CurrentJobID

    SET @CurrentJobID = NULL
    SET @CurrentJobName = NULL
    SET @CurrentCommandTSQL = NULL
    SET @CurrentCommandCmdExec = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentOutputFileNamePart01 = NULL
    SET @CurrentOutputFileNamePart02 = NULL
    SET @CurrentJobStepCommand = NULL
    SET @CurrentJobStepSubSystem = NULL
    SET @CurrentJobStepDatabaseName = NULL
    SET @CurrentOutputFileName = NULL

  END

END
GO

--Static variables - please do NOT change
DECLARE @dbname NVARCHAR(MAX) = '$(DATABASE_NAME)'
DECLARE @cmd NVARCHAR(MAX) = ''
DECLARE @errorMsg NVARCHAR(4000) = ''
DECLARE @errCount INT = 0
DECLARE @tmpObjTable TABLE (ObjName NVARCHAR(MAX), checkValue INT)

SET @errorMsg = 'Info: Execution of Ola Hallengren script finished'
RAISERROR(@errorMsg, 10, 1) WITH NOWAIT;
GO
--############################################################################################################################################
-- END: OLA HALLENGREN SCRIPT
--############################################################################################################################################


--############################################################################################################################################
-- START: STORED PROCEDURES
--############################################################################################################################################

USE $(DATABASE_NAME)
GO

-- Start: spr_ExecDatabaseBackupDiff

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupDiff]
AS
BEGIN
	DECLARE @cmd NVARCHAR(MAX) = 'EXEC [$(DATABASE_NAME)].[dbo].[DatabaseBackup] '

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

RAISERROR('Info: Create Stored Procedure "spr_ExecDatabaseBackupDiff" successful', 10, 1) WITH NOWAIT;
GO

-- END: spr_ExecDatabaseBackupDiff

-- Start: spr_ExecDatabaseBackupFull
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupFull]
AS
BEGIN
	DECLARE @cmd NVARCHAR(MAX) = 'EXEC [$(DATABASE_NAME)].[dbo].[DatabaseBackup] '

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

RAISERROR('Info: Create Stored Procedure "spr_ExecDatabaseBackupFull" successful', 10, 1) WITH NOWAIT;
GO
-- End: spr_ExecDatabaseBackupFull

-- Start: spr_ExecDatabaseBackupLog

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseBackupLog]
AS
BEGIN
	DECLARE @cmd NVARCHAR(MAX) = 'EXEC [$(DATABASE_NAME)].[dbo].[DatabaseBackup] '

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

RAISERROR('Info: Create Stored Procedure "spr_ExecDatabaseBackupLog" successful', 10, 1) WITH NOWAIT;
GO
-- End: spr_ExecDatabaseBackupLog

-- Start: spr_ExecDatabaseIntegrityCheck

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecDatabaseIntegrityCheck]
AS
BEGIN
	DECLARE @cmd NVARCHAR(MAX) = 'EXEC [$(DATABASE_NAME)].[dbo].[DatabaseIntegrityCheck] '

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

RAISERROR('Info: Create Stored Procedure "spr_ExecDatabaseIntegrityCheck" successful', 10, 1) WITH NOWAIT;
GO
-- END: spr_ExecDatabaseIntegrityCheck

-- Start: spr_ExecIndexOptimize
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_ExecIndexOptimize]
AS
BEGIN
	DECLARE @cmd NVARCHAR(MAX) = 'EXEC [$(DATABASE_NAME)].[dbo].[IndexOptimize] '

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

RAISERROR('Info: Create Stored Procedure "spr_ExecIndexOptimize" successful', 10, 1) WITH NOWAIT;
GO

-- End: spr_ExecIndexOptimize

-- Start: spr_Hexadecimal
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spr_Hexadecimal]
    @binvalue varbinary(256),
    @hexvalue varchar (514) OUTPUT
AS
BEGIN
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
END
GO

RAISERROR('Info: Create Stored Procedure "spr_Hexadecimal" successful', 10, 1) WITH NOWAIT;
GO
-- End: spr_Hexadecimal

-- Start: spr_HelpRevlogin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spr_HelpRevlogin] 
	@login_name sysname = NULL 
AS
BEGIN
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
	BEGIN
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
			FROM sys.server_principals p LEFT JOIN sys.syslogins l
				ON ( l.name = p.name ) 
			WHERE p.type IN ( 'S', 'G', 'U' ) --AND p.name <> 'sa'
	END
	ELSE
	BEGIN
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
			FROM sys.server_principals p LEFT JOIN sys.syslogins l
				ON ( l.name = p.name ) 
			WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name = @login_name
	END

	OPEN login_curs

	FETCH NEXT FROM login_curs 
		INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @is_sysadmin, @is_securityadmin, @is_serveradmin, @is_setupadmin, @is_processadmin, @is_diskadmin, @is_dbcreator, @is_bulkadmin
	
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
			ELSE 
			BEGIN -- SQL Server authentication
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
			IF EXISTS (SELECT 1 FROM master.sys.databases WHERE name = '$(DATABASE_NAME)')
			BEGIN
				INSERT INTO $(DATABASE_NAME).dbo.BackupLogins (RunDate, LoginName, CreateStatement)
				VALUES (getdate(), @name, @tmpstr)
			END
		END

		FETCH NEXT FROM login_curs 
			INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin, @is_sysadmin, @is_securityadmin, @is_serveradmin, @is_setupadmin, @is_processadmin, @is_diskadmin, @is_dbcreator, @is_bulkadmin
	END
	CLOSE login_curs
	DEALLOCATE login_curs
	RETURN 0
END
GO

RAISERROR('Info: Create Stored Procedure "spr_HelpRevlogin" successful', 10, 1) WITH NOWAIT;
GO
-- End: spr_HelpRevlogin

-- Start: spr_CleanupAdminDB
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_CleanupAdminDB]
AS
BEGIN
	-- dyn CMD
	DECLARE @cmd NVARCHAR(MAX) = ''
	
	DECLARE @StartTime DATETIME2(7)
	DECLARE @EndTime DATETIME2(7)
	-- Cursor Variables
	DECLARE @tableName NVARCHAR(MAX)
	DECLARE @fullName NVARCHAR(MAX)
	DECLARE @cleanupDays INT
	-- Cursor
	DECLARE curObjects CURSOR FOR
		SELECT a.name AS TableName,
			   '[' + b.name + '].[' + a.name + ']' AS FullName,
			   c.CleanupDays
		FROM sys.tables a
		INNER JOIN sys.schemas b
			on a.schema_id = b.schema_id
		LEFT JOIN CONFIG.tblCleanup c
			ON c.ObjectName = a.name
		WHERE b.name = 'dbo'

	OPEN curObjects

	FETCH NEXT FROM curObjects INTO @tableName, @fullName, @cleanupDays

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @StartTime = GETDATE()
		-- Ola Hallengren CommandLog Table --> StartDate
		IF(@tableName = 'CommandLog')
		BEGIN
			SET @cmd = ISNULL(('DELETE FROM ' + @fullName + ' WHERE StartTime < DATEADD(DAY,-' + CONVERT(NVARCHAR(MAX), @cleanupDays) + ', GETDATE());'), '');
		END
		ELSE
		BEGIN
			SET @cmd = ISNULL(('DELETE FROM ' + @fullName + ' WHERE RunDate < DATEADD(DAY,-' + CONVERT(NVARCHAR(MAX), @cleanupDays) + ', GETDATE());'), '');
		END

		BEGIN TRY
			EXEC sp_executesql @cmd
			SET @EndTime = GETDATE()
			INSERT INTO dbo.CommandLog (SchemaName, ObjectName, Command, CommandType, StartTime, EndTime, ErrorNumber, ErrorMessage)
			VALUES (
				'dbo',
				@tableName,
				@cmd,
				'Cleanup',
				@StartTime,
				@EndTime,
				NULL,
				NULL
			)
		END TRY
		BEGIN CATCH
			
			INSERT INTO dbo.CommandLog (SchemaName, ObjectName, Command, CommandType, StartTime, EndTime, ErrorNumber, ErrorMessage)
			VALUES (
				'dbo',
				@tableName,
				@cmd,
				'Cleanup',
				@StartTime,
				NULL,
				ERROR_NUMBER(),
				ERROR_MESSAGE()
			)
		END CATCH

		FETCH NEXT FROM curObjects INTO @tableName, @fullName, @cleanupDays
	END
	CLOSE curObjects
	DEALLOCATE curObjects
END

RAISERROR('Info: Create Stored Procedure "spr_CleanupAdminDB" successful', 10, 1) WITH NOWAIT;

-- End: spr_CleanupAdminDB

--Start: spr_CleanupHistory
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_CleanupHistory]
AS
BEGIN
	DECLARE @backupCleanupDate DATETIME
	DECLARE @backupCleanupDays INT = (
		SELECT CleanupDays*-1
		FROM CONFIG.tblCleanup
		WHERE ObjectName = 'BackupHistory'
	)
	SET @backupCleanupDate = DATEADD(DAY,@backupCleanupDays,GETDATE()) 
	EXECUTE msdb.dbo.sp_delete_backuphistory @oldest_date = @backupCleanupDate

	DECLARE @jobCleanupDate DATETIME
	DECLARE @jobCleanupDays INT = (
		SELECT CleanupDays*-1
		FROM CONFIG.tblCleanup
		WHERE ObjectName = 'JobHistory'
	)

	SET @jobCleanupDate = DATEADD(DAY, @jobCleanupDays, GETDATE())
	EXECUTE msdb.dbo.sp_purge_jobhistory @oldest_date = @jobCleanupDate
END
GO

RAISERROR('Info: Create Stored Procedure "spr_CleanupHistory" successful', 10, 1) WITH NOWAIT;
--END: spr_CleanupHistory

-- Start: spr_SplitDataFiles
USE [$(DATABASE_NAME)] -- set a database, in which you want to create this procedure (do not use system databases)
GO

/*
Author: Antonio Turkovic (Microsoft Data&AI CE)
Version: 202009-01
Supported SQL Server Versions: >= SQL Server 2016 RTM (Standard and Enterprise Edition)	

Description:
This script can be used to distribute data among "n" data files per filegroup.
It will create a stored procedure called "dbo.spr_SplitDataFiles".
It can be also used to increase or reduce the amount of data files while keeping an even data distribution (per filegroup).

WARNING: Running this procedure can take a very long time to process depending on the amount of data

Requirements:
- User must have SYSADMIN privileges
- Ensure you have enough disk space (2.5 - 3 times the data)
- Call the procedure only on the SQL Server itself to prevent any remote procedure timeouts
- BEFORE running the process, perform a FULL backup of your database (database will be set to SIMPLE recovery model)
- AFTER running the process, perform another FULL backup to start a new backup chain (database will be set to the initial recovery model)

Parameter:
	- @dbName: Specify the database you want to work with
		- Database must not be a member of an Availability Group
		- Ensure that no users are working on the database during the entire process

	- @fileGroup: Specify an existing filegroup in the database in which you want to split the data files
		- The filegroup must not be "read-only"
		- During the process, the "AUTOGROW_ALL_FILES" option will be set on this filegroup

	- @tempFileName: Specify a temporary filename that will hold the entire data in the specific filegroup
		- Ensure that there is enough disk space available (will be checked by the script)
		- you must provide the fullname of the file: eg.: D:\MSSQL\data\tempfile.ndf
		- The logical name of the file will be the filename without the extension: eg.: tempfile

	- @newFilename: Specify new files to which the data will be distributed
		- Ensure that there is enough disk space available (will not be checked by the script - error will be thrown)
		- you must specify at least 2 files
		- Use ";" to specify each file: eg.: D:\MSSQL\data\db_file01.ndf; D:\MSSQL\data\db_file02.ndf
		- you must provide the fullname for each file
		- the logical name of each file will be the filename without the extension: eg.: db_file01 / db_file02
		- each file will have the same initial size (number to the power of 2)
		- each file will have an autogrowth of 1024 MB configured
		- if you are working with the primary filegroup, make sure that you also count the MDF file to the amount of files
		- if you are working with the primary filegroup, the MDF file will be configured with the same initial size as for the new files

Best Practices:
	- Please apply the same best practices as for the tempdb
		- https://docs.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database?view=sql-server-ver15#optimizing-tempdb-performance-in-sql-server
		- Review section "Optimizing tempdb performance in SQL Server"
	- The amount of available logical CPUs = amount of data files (max 8 files)
	- To get the best performance, place each file on a separate disk / mountpoint

Example:
	- On a server with 4 CPUs
	- EXEC dbo.spr_SplitDataFiles @dbName = 'myDB',
								  @fileGroup = 'PRIMARY',
								  @tempFilename = 'D:\MSSQL\data\myDB_temp.ndf',
								  @newFilename = 'D:\MSSQL\data\myDB_file02.ndf;
												  D:\MSSQL\data\myDB_file03.ndf;
												  D:\MSSQL\data\myDB_file04.ndf'

Output:
	- Review the "Messages" for details about the process
*/


CREATE PROCEDURE dbo.spr_SplitDataFiles
	-- Specify a database name
	@dbName NVARCHAR(256) = '',
	-- Specify the filegroup in which you want to distribute the data (data can only be distributed in the same filegroup)
	@fileGroup NVARCHAR(256) = 'PRIMARY',
	-- In order to distribute the data, a temporary file is required, which will hold the entire data
	-- Provide the filename including the filepath, name and extension
	-- eg. D:\MSSQL\tempfile.ndf
	@tempFilename NVARCHAR(256) = '',
	-- Specify the new file names to which the data will be distributed
	-- Use ";" to specify multiple data files
	-- You need to specify at least 2 data files
	-- eg. D:\MSSQL\data01.ndf;D:\MSSQL\data02.ndf
	@newFilename NVARCHAR(MAX)	 = '',
	--Specify which user should be the owner of the jobs  (that will perform the actions)
	-- Default is "SA"
	@jobOwner NVARCHAR(256) = 'sa'
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Var for Dynamic SQL
	DECLARE @cmd NVARCHAR(MAX)

	-- Var for Dynamic Param
	DECLARE @Param NVARCHAR(2000)

	-- Var for INT return Values
	DECLARE @result BIGINT = 0

	-- Var for Job Command
	DECLARE @jobCmd NVARCHAR(4000)

	-- Var for XP_CMDShell 
	DECLARE @XPcmd VARCHAR(8000)

	--Var for Messages
	DECLARE @msg NVARCHAR(MAX)

	-- Server Name
	DECLARE @serverName NVARCHAR(512) = CONVERT(NVARCHAR(512), SERVERPROPERTY('Servername'))

	-- Date String
	DECLARE @thisDate NVARCHAR(32) = FORMAT(GETDATE(), 'yyyyMMdd')

	-- Time String
	DECLARE @thisTime NVARCHAR(32) = FORMAT(GETDATE(), 'HHmmss')

	-- SQL Version
	DECLARE @sqlVersion INT = (SELECT CONVERT(INT, SERVERPROPERTY('ProductMajorVersion')))
	
	-- Advanced Options Value
	DECLARE @chkAdvOptions INT = (SELECT CONVERT(INT, value) FROM master.sys.configurations WHERE name = 'show advanced options')

	-- XP CMDSHELL Value
	DECLARE @chkXPCMDShell INT = (SELECT CONVERT(INT, value) FROM master.sys.configurations WHERE name = 'xp_cmdshell')

	-- Total data content size
	DECLARE @totalContentSizeMB BIGINT = 0

	-- Move To Temp Job Name
	DECLARE @jobNameMoveToTemp NVARCHAR(256) = 'SplitDataFiles_' + CONVERT(NVARCHAR(100), NEWID())

	-- Move to Temp Job Description
	DECLARE @jobDescMoveToTemp NVARCHAR(4000) = 'Database: ' + @dbname + CHAR(13) + CHAR(10) +
	'Description: This is only a temporary job - it will be deleted afterwards' + CHAR(13) + CHAR(10) +
	'Purpose: Move data from all data files in specified filegroup to a single temporary data file'

	-- Move to Temp Step Name
	DECLARE @jobStepMoveToTemp NVARCHAR(256) = @jobNameMoveToTemp

	-- Move data to all Files Job Name
	DECLARE @jobNameSpreadData NVARCHAR(256) = 'SplitDataFiles_' + CONVERT(nvarchar(100), NEWID())

	--Move data to all Files Job Description
	DECLARE @jobDescSpreadData NVARCHAR(4000) = 'Database: ' + @dbname + CHAR(13) + CHAR(10) +
	'Description: This is only a temporary job - it will be deleted afterwards' + CHAR(13) + CHAR(10) +
	'Purpose: Move data from a temporary data file in specified filegroup to "n" data files'

	--Move data to all Files Job Step
	DECLARE @jobStepSpreadData NVARCHAR(256) = @jobDescSpreadData

	-- Job Id
	DECLARE @jobId UNIQUEIDENTIFIER

	-- Variable for all target files
	DECLARE @tblTargetFilenames TABLE (
		filepath NVARCHAR(256),
		logicalName NVARCHAR(256)
	)

	-- Variable for count of new files
	DECLARE @countTargetFilenames INT = 0

	-- Table for Disk free space
	DECLARE @diskFreeSpace TABLE (
		Drive NVARCHAR(MAX),
		FreeSpaceMB BIGINT
	)

	-- Tmp Table Disk FreeSpace for XP_CMDSHELL results
	DECLARE @tmpDiskSpace TABLE (
		result NVARCHAR(MAX)
	)

	-- Org Recovery Model
	DECLARE @orgRecoveryModel NVARCHAR(32)

	-- temp data file logical Name
	DECLARE @tempFileLogicalName NVARCHAR(256) = RTRIM(LTRIM(LEFT((RIGHT(@tempFilename, CHARINDEX('\', REVERSE(@tempFilename)) -1)), CHARINDEX('.', (RIGHT(@tempFilename, CHARINDEX('\', REVERSE(@tempFilename))))) -2)))

	-- Data Files to empty TABLE
	DECLARE @tblFilesToEmpty TABLE (
		fileId INT,
		logicalName NVARCHAR(256)
	)

	-- CHeck job Pct complete
	DECLARE @jobPctComplete NUMERIC(5,2) = 0.00

	-- new Initial data file Sizes
	DECLARE @newInitFileSizeMB BIGINT = 0

	-- new AutoGrow Size
	DECLARE @newAutoGrowSizeMB BIGINT = 1024

	--##################################################
	-- VALIDATION
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Validating requirements'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	-- must not be a systemDB
	IF(@dbName IN ('master', 'model', 'msdb', 'tempdb'))
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database must not be a System Database - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	--Check if user is SYSADMIN
	IF (IS_SRVROLEMEMBER('sysadmin') != 1)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | SYSADMIN privileges required - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Check if database exists
	IF NOT EXISTS (
		SELECT 1
		FROM master.sys.databases
		WHERE name = @dbName
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database not found - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Check if DB is in AG
	IF EXISTS (
		SELECT 1
		FROM master.sys.dm_hadr_database_replica_states
		WHERE database_id = DB_ID(@dbName)
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database is part of an Availability Group - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Check if at least SQL Server 2016
	IF(@sqlVersion < 13)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Script is only supported on SQL Server 2016 or newer - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	--Check if Filegroup exists
	SET @cmd = '
	IF NOT EXISTS (
		SELECT 1
		FROM ' + @dbName + '.sys.filegroups
		WHERE name = ''' + @fileGroup + '''
		AND type = ''FG''
	)
	BEGIN
		RAISERROR(''no filegroup'', 16, 1) WITH NOWAIT
	END
	'
	
	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Filegroup not found - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END CATCH
	
	-- Get Total Content Size to Move
	SET @cmd = '
	USE [' + @dbName + '];
	SELECT @dynResult = SUM(CAST(FILEPROPERTY(a.name, ''SpaceUsed'') AS INT) /128)
	FROM sys.database_files a
	LEFT JOIN sys.filegroups b
		ON a.data_space_id = b.data_space_id
	WHERE a.type = 0
	AND b.name = ''' + @fileGroup + ''';
	';
	SET @Param = '@dynResult BIGINT OUTPUT'
	EXEC sp_executesql @cmd, @param, @dynresult = @totalContentSizeMB OUTPUT

	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Total content size: ' + CONVERT(NVARCHAR(32), @totalContentSizeMB) + ' MB'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	-- Split Data Files to table
	SET @newFilename = REPLACE(@newFilename, CHAR(9), '');
	SET @newFilename = REPLACE(@newFilename, CHAR(13), '');
	SET @newFilename = REPLACE(@newFilename, CHAR(10), '');
	INSERT INTO @tblTargetFilenames (filepath, logicalName)
	SELECT REPLACE((REPLACE((LTRIM(RTRIM(value))), CHAR(13)+CHAR(10), '')), CHAR(9), '') AS [Filepath],
		   RTRIM(LTRIM(LEFT((RIGHT(value, CHARINDEX('\', REVERSE(value)) -1)), CHARINDEX('.', (RIGHT(value, CHARINDEX('\', REVERSE(value))))) -2))) AS [LogicalName]
	FROM string_split(@newFilename, ';')
	WHERE value IS NOT NULL
	AND value != ''
	
	-- Count Files
	SET @countTargetFilenames = (SELECT COUNT(1) FROM @tblTargetFilenames)

	IF(@countTargetFilenames IN (0,1))
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | You must specify at least 2 new filenames - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT
		RETURN;
	END

	-- Check if there is enough disk space for temp file
	-- Enable XP CMDSHELL
	IF(@chkXPCMDShell = 0)
	BEGIN
		IF(@chkAdvOptions = 0)
		BEGIN
			EXEC sp_configure 'show advanced options', 1;
			RECONFIGURE;
		END
		EXEC sp_configure 'xp_cmdshell', 1;
		RECONFIGURE;
	END
	
	-- Check Free Space on Disk for temp File
	SET @XPcmd = '
		powershell.exe -c "Get-Volume -FilePath ''' + CONVERT(VARCHAR(MAX), @tempFilename) + ''' | Select -ExpandProperty SizeRemaining"
	';
	INSERT INTO @tmpDiskSpace (result)
	EXEC xp_cmdshell @XPcmd

	-- Add data to disk free space table
	INSERT INTO @diskFreeSpace (Drive, FreeSpaceMB)
	SELECT TOP (1) @tempFilename, CONVERT(BIGINT, result) / 1024 / 1024 FROM @tmpDiskSpace;
	
	IF EXISTS (
		SELECT 1 FROM @diskFreeSpace
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Total free space on disk for temp file: ' + (SELECT CONVERT(NVARCHAR(MAX), FreeSpaceMB) FROM @diskFreeSpace) + ' MB'
		RAISERROR(@msg, 10, 1) WITH NOWAIT
		IF((SELECT FreeSpaceMB FROM @diskFreeSpace) < @totalContentSizeMB )
		BEGIN
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Not enough disk space available for temp file - terminating script'
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			RETURN;
		END
	END
	ELSE
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Drive information for temporary file not found - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END
	
	-- Disable XP_Cmdshell
	IF(@chkXPCMDShell = 0)
	BEGIN
		EXEC sp_configure 'xp_cmdshell', 0;
		RECONFIGURE;

		IF(@chkAdvOptions = 0)
		BEGIN
			EXEC sp_configure 'show advanced options', 0;
			RECONFIGURE;
		END
	END


	-- Set recovery model to SIMPLE
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Setting SIMPLE recovery model'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	SET @orgRecoveryModel = (
		SELECT recovery_model_desc
		FROM master.sys.databases
		WHERE name = @dbName
	);

	SET @cmd = '
		USE [master];
		ALTER DATABASE [' + @dbName + '] SET RECOVERY SIMPLE WITH NO_WAIT;
	';

	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not set SIMPLE recovery model - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	-- Get all files to empty from filegroup
	SET @cmd = '
		USE [' + @dbName + '];
		SELECT a.file_id, a.name
		FROM sys.database_files a
		LEFT JOIN sys.filegroups b
			ON a.data_space_id = b.data_space_id
		WHERE b.name = ''' + @fileGroup + '''
		AND a.type = 0
	'
	INSERT INTO @tblFilesToEmpty (fileId, logicalName)
	EXEC sp_executesql @cmd

	IF NOT EXISTS (
		SELECT 1 FROM @tblFilesToEmpty
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | No data files found to empty'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END

	--######################################
	-- Create temp file
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Adding temp data file'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	SET @cmd = '
		USE [master];
		ALTER DATABASE [' + @dbName + '] ADD FILE ( NAME = N''' + @tempFileLogicalName + ''', FILENAME = N''' + @tempFilename + ''' , SIZE = ' + CONVERT(NVARCHAR(MAX), @totalContentSizeMB) + 'MB , FILEGROWTH = 1024MB ) TO FILEGROUP [' + @fileGroup + '];
	'
	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not add temp data file' + CHAR(13) + CHAR(10) +
		'Error number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE();
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH
	--####################################################
	-- Generate Temp Job Step Command
	DECLARE @tmpTempFileId INT
	DECLARE @tmpTempLogicalName NVARCHAR(256)
	DECLARE curTempDBFiles CURSOR FOR
		SELECT fileId, logicalName
		FROM @tblFilesToEmpty
		ORDER BY fileId DESC

	OPEN curTempDBFiles

	-- Loop through all data files
	FETCH NEXT FROM curTempDBFiles INTO @tmpTempFileId, @tmpTempLogicalName
	SET @jobCmd = ''
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @jobCmd += 'USE [' + @dbName + '];' + CHAR(13) + CHAR(10) +
		'DBCC SHRINKFILE (N''' + @tmpTempLogicalName + ''' , EMPTYFILE);' + CHAR(13) + CHAR(10)

		IF(@tmpTempFileId != 1)
		BEGIN
			SET @jobCmd += 'USE [' + @dbName + '];' + CHAR(13) + CHAR(10) +
			'ALTER DATABASE [' + @dbName + ']  REMOVE FILE [' + @tmpTempLogicalName + '];' + CHAR(13) + CHAR(10)
		END
		
		FETCH NEXT FROM curTempDBFiles INTO @tmpTempFileId, @tmpTempLogicalName
	END

	CLOSE curTempDBFiles
	DEALLOCATE curTempDBFiles
	

	--##################################
	-- Create job for move to temp data file
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Create SQL Agent Job to move data to temp data file: ' + @jobNameMoveToTemp
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	BEGIN TRY
	EXEC    msdb.dbo.sp_add_job @job_name=@jobNameMoveToTemp, 
			@enabled=1, 
			@notify_level_eventlog=0, 
			@notify_level_email=0, 
			@notify_level_netsend=0, 
			@notify_level_page=0, 
			@delete_level=0, 
			@description=@jobDescMoveToTemp, 
			@category_name=N'[Uncategorized (Local)]', 
			@owner_login_name=@jobOwner;

	EXEC msdb.dbo.sp_add_jobstep @job_name = @jobNameMoveToTemp, @step_name=@jobNameMoveToTemp, 
			@step_id=1, 
			@cmdexec_success_code=0, 
			@on_success_action=1, 
			@on_success_step_id=0, 
			@on_fail_action=2, 
			@on_fail_step_id=0, 
			@retry_attempts=0, 
			@retry_interval=0, 
			@os_run_priority=0, @subsystem=N'TSQL', 
			@command=@jobCmd, 
			@database_name=N'master', 
			@flags=0;

	EXEC msdb.dbo.sp_add_jobserver @job_name = @jobNameMoveToTemp, @server_name =  @serverName;
	
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not create SQL Agent Job to move data to temp data file: ' + @jobNameMoveToTemp + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE()
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	-- Get Job Id
	SET @jobId = (
		SELECT [job_id] 
		FROM msdb.dbo.sysjobs 
		WHERE [name] = @jobNameMoveToTemp
	)

	--###################################
	-- Start job move to temp
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Starting job ' + @jobNameMoveToTemp
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	BEGIN TRY
		EXEC msdb.dbo.sp_start_job @job_name = @jobNameMoveToTemp
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not start SQL Agent Job to move data to temp data file: ' + @jobNameMoveToTemp + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE()
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	WAITFOR DELAY '00:00:10';

	WHILE (
		(SELECT a.stop_execution_date
		 FROM msdb.dbo.sysjobactivity a
		 INNER JOIN msdb.dbo.sysjobs b
			 ON a.job_id = b.job_id
		 WHERE b.name = @jobNameMoveToTemp) IS NULL
	)
	BEGIN
		SET @cmd = '
		USE [' + @dbName + '];
		SELECT @dynResult = SUM(CAST(FILEPROPERTY(a.name, ''SpaceUsed'') AS INT) /128)
		FROM sys.database_files a
		LEFT JOIN sys.filegroups b
			ON a.data_space_id = b.data_space_id
		WHERE a.type = 0
		AND b.name = ''' + @fileGroup + '''
		AND a.name = ''' + @tempFileLogicalName + ''' ;
		';
		SET @Param = '@dynResult BIGINT OUTPUT'
		EXEC sp_executesql @cmd, @param, @dynresult = @result OUTPUT

		IF(@totalContentSizeMB > 0)
		BEGIN
			SET @jobPctComplete = @result * 100.00 / @totalContentSizeMB
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Processed ' + CONVERT(NVARCHAR(MAX), @result) + ' MB (' + CONVERT(NVARCHAR(MAX), @jobPctComplete) + ' pct)';
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			WAITFOR DELAY '00:01:00';
		END
	END

	-- CHECK status of job
	IF EXISTS (
		SELECT 1
		FROM msdb.dbo.sysjobhistory
		WHERE step_name = @jobStepMoveToTemp
		AND ([message] LIKE '%Cannot move all contents of file "%" to other places to complete the emptyfile operation%'
			 OR [message] LIKE '%The step succeeded%')
	)
	BEGIN
		-- Count files in Filegroup
		SET @cmd = '
			USE [' + @dbName + '];
			SELECT @dynResult = COUNT(1)
			FROM sys.database_files a
			LEFT JOIN sys.filegroups b
				ON a.data_space_id = b.data_space_id
			WHERE a.type = 0
			AND b.name = ''' + @fileGroup + ''';
		';
		SET @Param = '@dynResult BIGINT OUTPUT'
		EXEC sp_executesql @cmd, @param, @dynresult = @result OUTPUT
		
		IF(
			((@fileGroup = 'PRIMARY') AND (@result = 2))
			OR
			((@fileGroup != 'PRIMARY') AND (@result = 1))
		)
		BEGIN
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Data has been moved to temporary file successfully';
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
		END
		ELSE
		BEGIN
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Data movement to temporary data file failed';
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | WARN | Please delete data movement agent job manually';
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			GOTO CleanupSection; 
		END
	END
	ELSE
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Data movement to temporary data file job failed';
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | ' + 
			(SELECT [message]
			FROM msdb.dbo.sysjobhistory
			WHERE step_name = '(Job outcome)'
			AND job_id = @jobId);
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | WARN | Please delete data movement agent job manually';
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END

	-- Delete Job Temp Movement
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Deleting SQL Agent job: ' + @jobNameMoveToTemp;
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	BEGIN TRY
		EXEC msdb.dbo.sp_delete_job @job_name = @jobNameMoveToTemp, @delete_history = 0
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | WARN | Could not delete SQL Agent job: ' + @jobNameMoveToTemp + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE();
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
	END CATCH


	--########################################
	-- Plan the new files
	IF(@fileGroup = 'PRIMARY')
	BEGIN
		SET @newInitFileSizeMB = FLOOR(POWER(2, CEILING(LOG(@totalContentSizeMB / (@countTargetFilenames + 1),2))))
	END
	ELSE
	BEGIN 
		SET @newInitFileSizeMB = FLOOR(POWER(2, CEILING(LOG(@totalContentSizeMB / @countTargetFilenames,2))))
	END
	
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Creating ' + CONVERT(NVARCHAR(10), @countTargetFilenames) + ' new files. All data files in this filegroup will have an initial size of ' + CONVERT(NVARCHAR(MAX), @newInitFileSizeMB) + ' MB.';
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	SET @cmd = 'USE [master];' + CHAR(13) + CHAR(10)
	SELECT @cmd += ISNULL(('ALTER DATABASE [' + @dbName + '] ADD FILE (NAME = N''' + logicalName + ''', FILENAME = N''' + filepath + ''', SIZE = ' + CONVERT(NVARCHAR(MAX), @newInitFileSizeMB) + 'MB, FILEGROWTH = ' + CONVERT(NVARCHAR(MAX), @newAutoGrowSizeMB) + 'MB ) TO FILEGROUP [' + @fileGroup + '];' + CHAR(13) + CHAR(10)), '')
	FROM @tblTargetFilenames
	ORDER BY logicalName ASC
	
	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not create new data files' + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	-- If it is in primary - shrink file to newInitialFileSize
	IF(@fileGroup = 'PRIMARY')
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Changing file size of MDF file'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		-- CHeck if MDF file is larger than newInitialSize
		IF(
			(SELECT size * 8 / 1024 
			 FROM master.sys.master_files
			 WHERE database_id = DB_ID(@dbName)
			 AND file_id = 1
			 AND type = 0
			) >= @newInitFileSizeMB
		)
		BEGIN
			-- Shrink file to initial size
			SET @cmd = '
				USE [' + @dbName + '];
				DBCC SHRINKFILE (N''' + (SELECT CONVERT(NVARCHAR(MAX), name) FROM master.sys.master_files WHERE type = 0 AND file_id = 1 AND database_id = DB_ID(@dbName)) + ''' , ' + CONVERT(NVARCHAR(MAX), @newInitFileSizeMB) + ');
			';
		END
		ELSE
		BEGIN
			SET @cmd = '
				USE [master];
				ALTER DATABASE [' + @dbName + '] MODIFY FILE ( NAME = N''' + (SELECT CONVERT(NVARCHAR(MAX), name) FROM master.sys.master_files WHERE type = 0 AND file_id = 1 AND database_id = DB_ID(@dbName)) + ''', SIZE = ' + CONVERT(NVARCHAR(MAX), @newInitFileSizeMB) + 'MB );
			';
		END

		-- Adjust AutoGrow 
		SET @cmd += '
			USE [master];
			ALTER DATABASE [' + @dbName + '] MODIFY FILE ( NAME = N''' + (SELECT CONVERT(NVARCHAR(MAX), name) FROM master.sys.master_files WHERE type = 0 AND file_id = 1 AND database_id = DB_ID(@dbName)) + ''', FILEGROWTH = ' + CONVERT(NVARCHAR(MAX), @newAutoGrowSizeMB) + 'MB );
		';

		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not adjust MDF data file size' + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			GOTO CleanupSection;
		END CATCH
	END

	-- Enable AUTOGROW_ALL_FILES
	-- Check if already set
	SET @cmd = '
		USE [' + @dbName + '];
		SELECT @dynResult = CONVERT(INT, is_autogrow_all_files)
		FROM sys.filegroups
		WHERE name = N''' + @fileGroup + '''
	'
	SET @Param = '@dynResult BIGINT OUTPUT'
	EXEC sp_executesql @cmd, @param, @dynresult = @result OUTPUT

	IF(@result = 0)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Enabling "AUTOGROW_ALL_FILES" feature on filegroup (DB in single-user mode)';
		RAISERROR(@msg, 10, 1) WITH NOWAIT;

		SET @cmd = '
			USE [master];
			ALTER DATABASE [' + @dbName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
			USE [' + @dbName + '];
			ALTER DATABASE [' + @dbName + '] MODIFY FILEGROUP [' + @fileGroup + '] AUTOGROW_ALL_FILES;
			USE [master];
			ALTER DATABASE [' + @dbName + '] SET MULTI_USER;
		'

		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not set "AUTOGROW_ALL_FILES" feature' + CHAR(13) + CHAR(10) +
				'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
				'Error Message: ' + ERROR_MESSAGE();
				RAISERROR(@msg, 10, 1) WITH NOWAIT;
				GOTO CleanupSection;
		END CATCH
	END
	
	--##################################
	-- Create Job to empty temp File
	SET @jobCmd = 'USE [' + @dbName + '];' + CHAR(13) + CHAR(10) +
	'DBCC SHRINKFILE (N''' + @tempFileLogicalName + ''' , EMPTYFILE);' + CHAR(13) + CHAR(10)
	
	SET @jobCmd += 'USE [' + @dbName + '];' + CHAR(13) + CHAR(10) +
	'ALTER DATABASE [' + @dbName + ']  REMOVE FILE [' + @tempFileLogicalName + '];' + CHAR(13) + CHAR(10)

	-- Create job to move data from temp file to new data files
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Create SQL Agent Job to move data from temp data file to new data files: ' + @jobNameSpreadData
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	BEGIN TRY
	EXEC    msdb.dbo.sp_add_job @job_name=@jobNameSpreadData, 
			@enabled=1, 
			@notify_level_eventlog=0, 
			@notify_level_email=0, 
			@notify_level_netsend=0, 
			@notify_level_page=0, 
			@delete_level=0, 
			@description=@jobDescSpreadData, 
			@category_name=N'[Uncategorized (Local)]', 
			@owner_login_name=@jobOwner;

	EXEC msdb.dbo.sp_add_jobstep @job_name = @jobNameSpreadData, @step_name=@jobNameSpreadData, 
			@step_id=1, 
			@cmdexec_success_code=0, 
			@on_success_action=1, 
			@on_success_step_id=0, 
			@on_fail_action=2, 
			@on_fail_step_id=0, 
			@retry_attempts=0, 
			@retry_interval=0, 
			@os_run_priority=0, @subsystem=N'TSQL', 
			@command=@jobCmd, 
			@database_name=N'master', 
			@flags=0;

	EXEC msdb.dbo.sp_add_jobserver @job_name = @jobNameSpreadData, @server_name =  @serverName;
	
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not create SQL Agent Job to move data from temp data file to new data files: ' + @jobNameSpreadData + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE()
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	-- Get Job id
	SET @jobId = (
		SELECT [job_id] 
		FROM msdb.dbo.sysjobs 
		WHERE [name] = @jobNameSpreadData
	)

	-- Start job
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Starting job: ' + @jobNameSpreadData
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	BEGIN TRY
		EXEC msdb.dbo.sp_start_job @job_name = @jobNameSpreadData
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not start SQL Agent Job: ' + @jobNameSpreadData + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE()
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		GOTO CleanupSection;
	END CATCH

	-- Monitor progress
	WAITFOR DELAY '00:00:10';

	WHILE (
		(SELECT a.stop_execution_date
		 FROM msdb.dbo.sysjobactivity a
		 INNER JOIN msdb.dbo.sysjobs b
			 ON a.job_id = b.job_id
		 WHERE b.name = @jobNameSpreadData) IS NULL
	)
	BEGIN
		SET @cmd = '
		USE [' + @dbName + '];
		SELECT @dynResult = SUM(CAST(FILEPROPERTY(a.name, ''SpaceUsed'') AS INT) /128)
		FROM sys.database_files a
		LEFT JOIN sys.filegroups b
			ON a.data_space_id = b.data_space_id
		WHERE a.type = 0
		AND b.name = ''' + @fileGroup + '''
		AND a.name != ''' + @tempFileLogicalName + ''' ;
		';
		SET @Param = '@dynResult BIGINT OUTPUT'
		EXEC sp_executesql @cmd, @param, @dynresult = @result OUTPUT

		IF(@totalContentSizeMB > 0)
		BEGIN
			SET @jobPctComplete = @result * 100.00 / @totalContentSizeMB
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Processed ' + CONVERT(NVARCHAR(MAX), @result) + ' MB (' + CONVERT(NVARCHAR(MAX), @jobPctComplete) + ' pct)';
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			WAITFOR DELAY '00:01:00';
		END
	END


	-- Check job status
	-- CHECK status of job
	IF EXISTS (
		SELECT 1
		FROM msdb.dbo.sysjobhistory
		WHERE step_name = @jobNameSpreadData
		AND [message] LIKE '%The step succeeded%'
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Splitting data to multiple data files successful';
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
	END
	ELSE
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Splitting data to multiple data failed' + CHAR(13) + CHAR(10) +
		(SELECT CONVERT(NVARCHAR(MAX), message)
		 FROM msdb.dbo.sysjobhistory
		 WHERE step_name = '(Job outcome)'
		 AND job_id = @jobId)
		 RAISERROR(@msg, 10, 1) WITH NOWAIT;
	END

	-- Delete Job Spread Data
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Deleting SQL Agent job: ' + @jobNameSpreadData
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	BEGIN TRY
		EXEC msdb.dbo.sp_delete_job @job_name = @jobNameSpreadData, @delete_history = 0
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not delete SQL Agent job: ' + @jobNameSpreadData
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
	END CATCH

	--########################################
	-- Cleanup
	GOTO CleanupSection;
	CleanupSection:
	-- Change Recovery Model to org Value
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Setting ' + @orgRecoveryModel + ' recovery model'
	SET @cmd = '
		USE [master];
		ALTER DATABASE [' + @dbName + '] SET RECOVERY ' + @orgRecoveryModel + ' WITH NO_WAIT;
	';
	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not set recovery model to ' + @orgRecoveryModel
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
	END CATCH
END
GO
-- END: spr_SplitDataFiles

-- Start: spr_ManageVLFs
USE [$(DATABASE_NAME)] -- set a database, in which you want to create this procedure (do not use system databases)
GO

/*
Author: Antonio Turkovic (Microsoft Data&AI CE)
Version: 202009-01
Supported SQL Server Versions: >= SQL Server 2016 SP2 (Standard and Enterprise Edition)	

Description:
This script can be used to distribute optimize the amount of VLFs (virtual log files).
It will create a stored procedure called "dbo.spr_ManageVLFs".

Requirements:
- User must have SYSADMIN privileges
- BEFORE running the process, perform a FULL backup of your database (database will be set to SIMPLE recovery model)
- AFTER running the process, perform another FULL backup to start a new backup chain (database will be set to the initial recovery model)
- Log file must be larger than 512 MB
- Only one Transaction log file is allowed

Remark: 
- If the database has a larger log file than 64 GB this script will only size it up to 64 GB.
- After that, autogrowth events will trigger automatically to size the log to its required size

Parameter:
	- @dbName: Specify the database you want to work with
		- Database must not be a member of an Availability Group
		- Ensure that no users are working on the database during the entire process

Best Practices:
	- It is best practice to reduce the amount of VLFs, if there are more than 1000
		- run "DBCC LOGINFO" or "SELECT * FROM master.sys.dm_db_log_info(DB_ID('database_name'))" to get total VLF count
	- This script applies all best practices according to docs.microsoft.com
		- https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-log-architecture-and-management-guide?view=sql-server-ver15#physical_arch

Example:
	- on a database with a current log size of 17937 MB having 897 VLFs
	- EXEC dbo.spr_ManageVLFs @dbName = 'myDB'
		- New log file size will be 16384 MB (pre-sized in 8192 MB steps), autogrowth set to 512 MB and a total of 34 VLFs 
Output:
	- Review the "Messages" for details about the process

*/

CREATE PROCEDURE spr_ManageVLFs
	-- Specify the database you want to work with
	@dbName NVARCHAR(256) = ''
AS
BEGIN
	
	SET NOCOUNT ON;

	-- Var for Dynamic SQL
	DECLARE @cmd NVARCHAR(MAX)

	-- Var for RAISERROR messages
	DECLARE @msg NVARCHAR(4000)
	
	-- Recovery Model
	DECLARE @currRecoveryModel NVARCHAR(32)

	-- Org VLF Count
	DECLARE @orgVLFCount BIGINT = 0

	-- New VLF Count
	DECLARE @newVLFCount INT = 0

	-- Store current Log File size
	DECLARE @currLogSizeMB BIGINT = 0

	-- Recommended Grow steps
	DECLARE @growStepsMB INT = 0

	--Recommended AUTOGrow Size
	DECLARE @autoGrowMB INT = 512
	DECLARE @tmpGrowMB INT = 0

	--How many times to grow the log in larger extents
	DECLARE @growLogCounter INT = 0

	-- How man times to shrink the file
	DECLARE @shrinkLoops INT = 20
	DECLARE @i INT = 0

	-- Log file logical Name
	DECLARE @logName NVARCHAR(256)


	--#############################################################
	-- VERIFICATION
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Starting validation'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	-- Check if database is in an AG
	IF EXISTS (
		SELECT 1
		FROM sys.dm_hadr_database_replica_states
		WHERE database_id = DB_ID(@dbName)
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database "' + @dbName + '" is member of an Availability Group.'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Check if DB is SysDB
	IF(@dbName IN ('master', 'model', 'msdb', 'tempdb'))
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database must not be a System DB'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Get VLFs Count
	SET @orgVLFCount = (SELECT COUNT(1) FROM master.sys.dm_db_log_info(DB_ID(@dbName)))
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Current VLF count = ' + CONVERT(NVARCHAR(32), @orgVLFCount)
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	-- Check if there are more than 1 log file --> terminate
	IF(
		(
			SELECT COUNT(1)
			FROM master.sys.master_files
			WHERE type = 1
			AND database_id = DB_ID(@dbName)
		)
		> 1
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Database has more than one log file - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- Get Logfilename
	SET @logName = (
		SELECT name 
		FROM master.sys.master_files 
		WHERE database_id = DB_ID(@dbName)
		AND type = 1
	)

	-- Get Log Size
	SET @currLogSizeMB = (
		SELECT size * 8 / 1024
		FROM master.sys.master_files
		WHERE database_id = DB_ID(@dbName)
		AND type = 1
	)

	-- Calculate new size, grow size

	-- Check how many times can 8192 MB fit in current logsize
	IF(((@currLogSizeMB / 8192) > 0) AND (@growStepsMB = 0))
	BEGIN
		SET @growStepsMB = 8192
	END

	-- 4096
	IF(((@currLogSizeMB / 4096) > 0) AND (@growStepsMB = 0))
	BEGIN
		SET @growStepsMB = 4096
	END

	-- 2048
	IF(((@currLogSizeMB / 2048) > 0) AND (@growStepsMB = 0))
	BEGIN
		SET @growStepsMB = 2048
	END

	-- 1024
	IF(((@currLogSizeMB / 1024) > 0) AND (@growStepsMB = 0))
	BEGIN
		SET @growStepsMB = 1024
	END

	-- 512
	IF(((@currLogSizeMB / 512) > 0) AND (@growStepsMB = 0))
	BEGIN
		SET @growStepsMB = 512
	END

	-- too small
	IF(@growStepsMB = 0)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | WARN | Current log file size is too small - nothing to do - terminating script'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END

	-- SET grow log counter
	IF((@currLogSizeMB / @growStepsMB) >= 8)
	BEGIN
		SET @growLogCounter = 8
	END
	ELSE
	BEGIN
		SET @growLogCounter = @currLogSizeMB / @growStepsMB
	END

	--###########################################
	-- Processing
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Starting process'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	-- Check if database is in Simple mode
	SET @currRecoveryModel = (
		SELECT recovery_model_desc 
		FROM sys.databases
		WHERE name = @dbName
	)

	IF (@currRecoveryModel != 'SIMPLE')
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Configuring SIMPLE recovery model'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;

		SET @cmd = '
			USE [master];
			ALTER DATABASE [' + @dbName + '] SET RECOVERY SIMPLE WITH NO_WAIT;
		';
		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not change recovery model to SIMPLE' + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(32), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			RETURN;
		END CATCH
	END
	-- Shrink log file
	SET @cmd = '
		USE [' + @dbName + '];
		DBCC SHRINKFILE (N''' + @logName + ''' , 1);
	'
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Shrinking log file to 1 MB'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	WHILE (@i <= @shrinkLoops)
	BEGIN
		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Shrink log file operation failed' + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(32), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			RETURN;
		END CATCH
		SET @i += 1;
	END

	--#############################################
	-- Get new size of log
	-- if new size is larger than 1 GB --> cancel query
	IF(
		(
			SELECT size * 8 / 1024
			FROM master.sys.master_files
			WHERE database_id = DB_ID(@dbName)
			AND type = 1
		) > 1024
	)
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Shrink operations failed - could not shrink log file to smaller size than 1024 MB.' + CHAR(13) + CHAR(10) +
		'If the log gets too fragmented over time it can happen, that shrink operations fail or are ineffective.' + CHAR(13) + CHAR(10) +
		'Please proceed manually!'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END
	
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Starting log pre-sizing'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	-- Resize LOG
	SET @cmd = 'ALTER DATABASE [' + @dbName + '] MODIFY FILE ( NAME = N''' + @logName + ''', SIZE = ' + CONVERT(NVARCHAR(32), @growStepsMB) + 'MB )';
	SET @tmpGrowMB = @growStepsMB

	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Configuring Log Size: ' + CONVERT(NVARCHAR(32), @tmpGrowMB) + ' MB'
	RAISERROR(@msg, 10, 1) WITH NOWAIT;

	BEGIN TRY
		EXEC sp_executesql @cmd
	END TRY
	BEGIN CATCH
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Pre-Sizing log to ' + CONVERT(NVARCHAR(32), @tmpGrowMB) + ' MB failed' + CHAR(13) + CHAR(10) +
		'Error Number: ' + CONVERT(NVARCHAR(32), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
		'Error Message: ' + ERROR_MESSAGE();
		RAISERROR(@msg, 10, 1) WITH NOWAIT;
		RETURN;
	END CATCH

	WHILE @growLogCounter != 1
	BEGIN
		SET @tmpGrowMB += @growStepsMB
		SET @cmd = 'ALTER DATABASE [' + @dbName + '] MODIFY FILE ( NAME = N''' + @logName + ''', SIZE = ' + CONVERT(NVARCHAR(32), @tmpGrowMB) + 'MB )';

		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Configuring Log Size: ' + CONVERT(NVARCHAR(32), @tmpGrowMB) + ' MB'
		RAISERROR(@msg, 10, 1) WITH NOWAIT;

		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Pre-Sizing log to ' + CONVERT(NVARCHAR(32), @tmpGrowMB) + ' MB failed' + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(32), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			RETURN;
		END CATCH
		
		SET @growLogCounter = @growLogCounter - 1
	END

	-- SET AUTOGROW
	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Configuring auto-growth setting to ' + CONVERT(NVARCHAR(32), @autoGrowMB) + ' MB';
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	SET @cmd = '
	USE [master];
	ALTER DATABASE [' + @dbName + '] MODIFY FILE ( NAME = N''' + @logName + ''', FILEGROWTH = ' + CONVERT(NVARCHAR(32), @autoGrowMB) + 'MB );
	';
	EXEC sp_executesql @cmd

	-- RESET Recovery Model
	IF(@currRecoveryModel != 'SIMPLE')
	BEGIN
		SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | Reconfiguring recovery model to ' + @currRecoveryModel + CHAR(13) + CHAR(10) +
		'Please perform a FULL backup to initiate the backup chain';
		RAISERROR(@msg, 10, 1) WITH NOWAIT;

		SET @cmd = '
			USE [master];
			ALTER DATABASE [' + @dbName + '] SET RECOVERY ' + @currRecoveryModel + ' WITH NO_WAIT;
		';
		BEGIN TRY
			EXEC sp_executesql @cmd
		END TRY
		BEGIN CATCH
			SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | ERROR | Could not change recovery model to ' + @currRecoveryModel + CHAR(13) + CHAR(10) +
			'Error Number: ' + CONVERT(NVARCHAR(32), ERROR_NUMBER()) + CHAR(13) + CHAR(10) +
			'Error Message: ' + ERROR_MESSAGE();
			RAISERROR(@msg, 10, 1) WITH NOWAIT;
			RETURN;
		END CATCH

	END

	-- Get new VLF Count
	SET @newVLFCount = (SELECT COUNT(1) FROM master.sys.dm_db_log_info(DB_ID(@dbName)))

	SET @msg = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') + ' | INFO | VLF optimization finished - new VLF Count = ' + CONVERT(NVARCHAR(32), @newVLFCount)
	RAISERROR(@msg, 10, 1) WITH NOWAIT;
	RETURN;

END
GO

-- End: spr_ManageVLFs

--############################################################################################################################################
-- END: STORED PROCEDURES
--############################################################################################################################################

--##################################################################################################################
-- AGENT JOBS
--##################################################################################################################

USE [msdb]
GO

-- Start: 01_MAINT_BACKUP_FULL
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'01_MAINT_BACKUP_FULL',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Full Backup Job for all databases based on Ola Hallengren Scripts',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'Full Backup Schedule',
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
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DECLARE STEP 1 COMMAND
	DECLARE @cmd1 NVARCHAR(MAX) = N'exec spr_ExecDatabaseBackupFull'

	-- ADD JOB STEP 1
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Full Backup',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'$(DATABASE_NAME)', 
		@flags=0
	
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "01_MAINT_BACKUP_FULL" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "01_MAINT_BACKUP_FULL"', 16, 1) WITH NOWAIT;
END CATCH
GO
-- END: 01_MAINT_BACKUP_FULL

-- START: 02_MAINT_BACKUP_DIFF
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'02_MAINT_BACKUP_DIFF',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Differential Backup Job for all databases based on Ola Hallengren Scripts',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'Diff Backup Schedule',
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
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DECLARE STEP 1 COMMAND
	DECLARE @cmd1 NVARCHAR(MAX) = N'exec spr_ExecDatabaseBackupDiff'

	-- ADD JOB STEP 1
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Diff Backup',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'$(DATABASE_NAME)', 
		@flags=0
	
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "02_MAINT_BACKUP_DIFF" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "02_MAINT_BACKUP_DIFF"', 16, 1) WITH NOWAIT;
END CATCH
GO
-- END: 02_MAINT_BACKUP_DIFF

-- START: 03_MAINT_BACKUP_LOG

BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'03_MAINT_BACKUP_LOG',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Log Backup Job for all databases based on Ola Hallengren Scripts',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'Log Backup Schedule',
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
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DECLARE STEP 1 COMMAND
	DECLARE @cmd1 NVARCHAR(MAX) = N'exec spr_ExecDatabaseBackupLog'

	-- ADD JOB STEP 1
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Log Backup',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'$(DATABASE_NAME)', 
		@flags=0
	
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "03_MAINT_BACKUP_LOG" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "03_MAINT_BACKUP_LOG"', 16, 1) WITH NOWAIT;
END CATCH
GO
-- END: 03_MAINT_BACKUP_LOG

-- START: 04_MAINT_INDEX_STATS
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'04_MAINT_INDEX_STATS',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Index and Statistics maintenance for all databases based on Ola Hallengren Scripts',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'IndexOptimize Schedule',
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
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DECLARE STEP 1 COMMAND
	DECLARE @cmd1 NVARCHAR(MAX) = N'exec spr_ExecIndexOptimize'

	-- ADD JOB STEP 1
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'IndexOptimize',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'$(DATABASE_NAME)', 
		@flags=0
	
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "04_MAINT_INDEX_STATS" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "04_MAINT_INDEX_STATS"', 16, 1) WITH NOWAIT;
END CATCH
GO
-- END: 04_MAINT_INDEX_STATS

-- START: 05_MAINT_CHECKDB
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'05_MAINT_CHECKDB',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Database Consistency checks for all databases based on Ola Hallengren Scripts',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'CHECKDB Schedule',
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
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DECLARE STEP 1 COMMAND
	DECLARE @cmd1 NVARCHAR(MAX) = N'exec spr_ExecDatabaseIntegrityCheck'

	-- ADD JOB STEP 1
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'CHECKDB',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'$(DATABASE_NAME)', 
		@flags=0
	
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "05_MAINT_CHECKDB" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "05_MAINT_CHECKDB"', 16, 1) WITH NOWAIT;
END CATCH
GO

-- END: 05_MAINT_CHECKDB

-- START: 06_MAINT_BACKUP_OBJECTS
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'06_MAINT_BACKUP_OBJECTS',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Backup SQL Server Instance objects',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'Backup Objects Schedule',
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130625, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput


	-- DECLARE STEP 1 COMMAND -- LOGINS
	DECLARE @cmd1 NVARCHAR(MAX) = N'EXEC $(DATABASE_NAME).dbo.spr_HelpRevlogin'

	-- DECLARE STEP 2 COMMAND -- AGENT JOBS
		DECLARE @cmd2 NVARCHAR(MAX) = N'#Backup AgentJobs to AdminDB Table
$MySQLInstance = "' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY('Servername')) + '"


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
        INSERT INTO [$(DATABASE_NAME)].[dbo].[BackupJobs] (RunDate, JobName, CreateJobStatement)
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

$objConnection.Close()';

	-- DECLARE STEP 3 COMMAND  -- ALERTS
		DECLARE @cmd3 NVARCHAR(MAX) = N'[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null

$mySQLInstance = "' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY('Servername')) +'"
$ConnectionString = "Server=$mySQLInstance;Trusted_Connection=True;"
$Conn = New-Object System.Data.SqlClient.SQLConnection($ConnectionString);

#SMO Connector
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $mySQLInstance

#Get Alerts
$myAlerts = $srv.JobServer.Alerts



if($myAlerts.Count -gt 0)
{

    Try{$Conn.Open();}
    Catch{
        Write-Error "Error connecting to sql server instance"
        Continue
    }

    #WriteToAdminDB
    foreach($alert in $myAlerts)
    {
        $tmpAlertName = $alert.Name;
        $tmpAlertScript = $alert.Script();
        $tmpAlertScript = $tmpAlertScript -replace ("''", "[!%!]")

        $cmd = "
            INSERT INTO [$(DATABASE_NAME)].[dbo].[BackupAlerts]
                ([RunDate]
                ,[AlertName]
                ,[CreateStatement])
           VALUES (
                GETDATE(),
                ''" + $tmpAlertName + "'',
                ''" + $tmpAlertScript + "''
           )
        ";
        $cmdObj = New-Object System.Data.SqlClient.SqlCommand
        $cmdObj.Connection = $Conn
        $cmdObj.CommandText = $cmd

        $cmdObj.ExecuteScalar();

    }

    $Conn.Close();

}'



		-- DECLARE STEP 4 COMMAND -- OPERATORS
		DECLARE @cmd4 NVARCHAR(MAX) = N'
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null

$mySQLInstance = "' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY('Servername')) +'"
$ConnectionString = "Server=$mySQLInstance;Trusted_Connection=True;"
$Conn = New-Object System.Data.SqlClient.SQLConnection($ConnectionString);

#SMO Connector
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $mySQLInstance

#Get Operators
$myOperators = $srv.JobServer.Operators



if($myOperators.Count -gt 0)
{

    Try{$Conn.Open();}
    Catch{
        Write-Error "Error connecting to sql server instance"
        Continue
    }

    #WriteToAdminDB
    foreach($operator in $myOperators)
    {
        $tmpOperatorName = $operator.Name;
        $tmpOperatorScript = $operator.Script();
        $tmpOperatorScript = $tmpOperatorScript -replace ("''", "[!%!]")

        $cmd = "
            INSERT INTO [$(DATABASE_NAME)].[dbo].[BackupOperators]
                ([RunDate]
                ,[OperatorName]
                ,[CreateStatement])
           VALUES (
                GETDATE(),
                ''" + $tmpOperatorName + "'',
                ''" + $tmpOperatorScript + "''
           )
        ";
        $cmdObj = New-Object System.Data.SqlClient.SqlCommand
        $cmdObj.Connection = $Conn
        $cmdObj.CommandText = $cmd
        #Write-Host $cmd

        $cmdObj.ExecuteScalar();

    }

    $Conn.Close();

}'

	-- ADD JOB STEP 1 -- LOGINS
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Backup Logins',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL',
		@command=@cmd1, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 2 -- BACKUP JOBS
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Backup Agent Jobs',
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=@cmd2, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 3 -- BACKUP ALERTS
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Backup Alerts',
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=@cmd3, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 4 -- BACKUP OPERATOR
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Backup Operators',
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, -- Change to add more steps --> 3 = next Step, 1 = finish
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=@cmd4, 
		@database_name=N'master', 
		@flags=0

	RAISERROR('Info: Create Agent Job "06_MAINT_BACKUP_OBJECTS" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "06_MAINT_BACKUP_OBJECTS"', 16, 1) WITH NOWAIT;
END CATCH
GO
-- END: 06_MAINT_BACKUP_OBJECTS

-- START: 08_MAINT_CLEANUP_TASKS
BEGIN TRY
	DECLARE @jobIdOutput binary(16)
	-- CREATE JOB
	EXEC msdb.dbo.sp_add_job @job_name = N'08_MAINT_CLEANUP_TASKS',
		@enabled = $(EnableJobs),
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Cleanup Tasks for AdminDB Tables, System Tables and Error Logs',
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobIdOutput OUTPUT
	EXEC msdb.dbo.sp_add_jobschedule @job_id = @jobIdOutput, @name = N'Cleanup Schedule',
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180116, 
		@active_end_date=99991231, 
		@active_start_time=500, 
		@active_end_time=235959
	EXEC msdb.dbo.sp_add_jobserver @job_id = @jobIdOutput

	-- DROP OLD STEPS
	EXEC msdb.dbo.sp_delete_jobstep @job_id = @jobIdOutput, @step_id = 0

	-- DECLARE STEP 1 COMMAND --> AdminDB
	DECLARE @cmd1 NVARCHAR(MAX) = N'EXEC $(DATABASE_NAME).dbo.spr_CleanupAdminDB'

	-- DECLARE STEP 2 COMMAND --> History Tables
	DECLARE @cmd2 NVARCHAR(MAX) = N'EXEC $(DATABASE_NAME).dbo.spr_CleanupHistory'

	-- DECLARE STEP 3 COMMAND --> Cycle Error Log
	DECLARE @cmd3 NVARCHAR(MAX) = N'EXEC msdb.dbo.sp_cycle_errorlog'

	-- DECLARE STEP 4 COMMAND --> Cycle Agent Log
	DECLARE @cmd4 NVARCHAR(MAX) = N'EXEC msdb.dbo.sp_cycle_agent_errorlog'

	-- DECLARE STEP 5 COMMAND --> Cleanup Mail Log
	DECLARE @cmd5 NVARCHAR(MAX) = N'EXEC msdb.dbo.sysmail_delete_log_sp'

	-- ADD JOB STEP 1 -- AdminDB
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'AdminDB Cleanup up according to CONFIG.tblCleanup',
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd1, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 2 -- History Tables
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Cleanup History Tables Backup and Jobs',
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd2, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 3 -- Cycle Error Log
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Recycle Error Log',
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd3, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 4 -- Cycle Agent Error Log
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Recycle Agent Log',
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd4, 
		@database_name=N'master', 
		@flags=0

	-- ADD JOB STEP 5 -- Cleanup Mail Log
	EXEC msdb.dbo.sp_add_jobstep @job_id = @jobIdOutput, @step_name = N'Cleanup Mail Log',
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@cmd5, 
		@database_name=N'master', 
		@flags=0
	EXEC msdb.dbo.sp_update_job @job_id = @jobIdOutput, @start_step_id = 1

	RAISERROR('Info: Create Agent Job "08_MAINT_CLEANUP_TASKS" successful', 10, 1) WITH NOWAIT
END TRY
BEGIN CATCH
	THROW;
	RAISERROR('Error: Could not create Agent Job "08_MAINT_CLEANUP_TASKS"', 16, 1) WITH NOWAIT;
END CATCH

-- END: 08_MAINT_CLEANUP_TASKS

/* START: CREATE VIEWS */
USE [$(DATABASE_NAME)]
GO
/****** Object:  View [dbo].[uvw_GetLogins]    Script Date: 04.07.2018 14:59:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[uvw_GetLogins]
AS
	SELECT * FROM dbo.BackupLogins
	WHERE RunDate >= (SELECT DATEADD(SECOND, -1, MAX(RunDate)) FROM BackupLogins);
GO
ALTER AUTHORIZATION ON [dbo].[uvw_GetLogins] TO  SCHEMA OWNER;
GO
RAISERROR('Info: Create View "uvw_GetLogins" successful', 10, 1) WITH NOWAIT;
GO
/****** Object:  View [dbo].[uvw_GetAlerts]    Script Date: 04.07.2018 14:59:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[uvw_GetAlerts]
AS
	SELECT * FROM dbo.BackupAlerts
	WHERE RunDate >= (SELECT DATEADD(SECOND, -1, MAX(RunDate)) FROM BackupAlerts);
GO
ALTER AUTHORIZATION ON [dbo].[uvw_GetAlerts] TO  SCHEMA OWNER;
GO
RAISERROR('Info: Create View "uvw_GetAlerts" successful', 10, 1) WITH NOWAIT;
GO

/****** Object:  View [dbo].[uvw_GetJobs]    Script Date: 04.07.2018 14:59:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[uvw_GetJobs]
AS
	SELECT * FROM dbo.BackupJobs
	WHERE RunDate >= (SELECT DATEADD(SECOND, -1, MAX(RunDate)) FROM BackupJobs);
GO
ALTER AUTHORIZATION ON [dbo].[uvw_GetJobs] TO  SCHEMA OWNER;
GO
RAISERROR('Info: Create View "uvw_GetJobs" successful', 10, 1) WITH NOWAIT;
GO

/****** Object:  View [dbo].[uvw_GetOperators]    Script Date: 04.07.2018 14:59:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[uvw_GetOperators]
AS
	SELECT * FROM dbo.BackupOperators
	WHERE RunDate >= (SELECT DATEADD(SECOND, -1, MAX(RunDate)) FROM BackupOperators);
GO
ALTER AUTHORIZATION ON [dbo].[uvw_GetOperators] TO  SCHEMA OWNER;
GO
RAISERROR('Info: Create View "uvw_GetOperators" successful', 10, 1) WITH NOWAIT;
GO


/* END: CREATE VIEWS */
