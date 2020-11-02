namespace AdoNet
{
    using System;
    using System.Data.SqlClient;
    using System.IO;

    public class Executioner
    {
        private readonly Action OnExecuteAction;
        private static readonly string databasePath = Path.Combine(Directory.GetCurrentDirectory().Replace("bin\\Debug", string.Empty), "DataSet1.mdf");
        private static SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder()
        {
            ["Data Source"] = "(LocalDB)\\MSSQLLocalDB",
            ["AttachDbFilename"] = databasePath,
            ["integrated Security"] = true
        };

        public Executioner(string name, string[] args)
        {
            switch (name)
            {
                case "init":
                    OnExecuteAction = Init;
                    break;

                case "lecture":
                    OnExecuteAction = () => { Lecture(args[0], args[1]); };
                        break;

                case "student":
                    OnExecuteAction = () => { Student(args[0]); };
                    break;

                case "attend":
                    OnExecuteAction = () => { Attend(args[0], args[1], args[2]); };
                    break;

                case "report":
                    OnExecuteAction = Report;
                    break;

                case "help":
                    OnExecuteAction = Help;
                    break;

                default:
                    throw new NotImplementedException();
            }
        }

        public bool TryExecute(out Exception exc)
        {
            try
            {
                OnExecuteAction();
                exc = null;
                return true;
            }
            catch (Exception ex)
            {
                exc = ex;
                return false;
            }
        }

        private static void Init()
        {
            using (var connection = new SqlConnection(builder.ToString()))
            {
                connection.Open();
                using (var command = connection.CreateCommand())
                {
                    try
                    {
                        command.CommandText =
                            "CREATE TABLE Students (Id INT PRIMARY KEY IDENTITY (1, 1), Name NVARCHAR(50) NOT NULL) \n" +
                            "CREATE TABLE Lecture (Id INT PRIMARY KEY IDENTITY (1, 1), Date DATE, Topic NVARCHAR(50)) \n" +
                            "CREATE TABLE Attendance (LectureDate INT REFERENCES Lecture (ID), StudentName INT REFERENCES Students (ID), Mark INT)";
                        command.ExecuteNonQuery();

                        command.CommandText =
@"CREATE PROCEDURE MarkAttendance 
	@StudentName NVARCHAR(50),
	@LectureTopic NVARCHAR(50),
	@Mark INT NULL
AS
BEGIN
IF NOT EXISTS (SELECT Name FROM Students WHERE Name = @StudentName)
BEGIN
	INSERT INTO Students VALUES (@StudentName)
END

IF NOT EXISTS (SELECT Topic FROM Lecture WHERE Topic = @LectureTopic)
BEGIN
	INSERT INTO Lecture (Topic) VALUES (@LectureTopic)
END

INSERT INTO Attendance (LectureDate, StudentName, Mark)
SELECT l.Id, s.Id, @Mark
FROM Students as s, Lecture as l
WHERE s.Name = @StudentName AND l.Topic = @LectureTopic
END";

                        command.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                        command.CommandText =
                            "DROP TABLE Attendance, Students, Lecture \n" +
                            "DROP PROCEDURE MarkAttendance";
                        command.ExecuteNonQuery();

                        Console.WriteLine("Please run -init again");
                    }
                }
            }
        }

        private static void Lecture(string date, string topic)
        {
            ExecuteSQL($"INSERT INTO Lecture (Date, Topic) VALUES ('{date}', '{topic}')");
        }

        private static void Student(string name)
        {
            ExecuteSQL($"INSERT INTO Students (Name) VALUES ('{name}')");
        }

        private static void Attend(string studName, string date, string mark)
        {
            if (int.TryParse(studName, out _) && int.TryParse(date, out _))
            {
                ExecuteSQL($"INSERT INTO Attendance VALUES ('{studName}', '{date}', {mark})");
            }
            else
            {
                ExecuteSQL($"EXEC MarkAttendance '{studName}', {date}, {mark}");
            }
        }

        private static void Report()
        {
            using (var connection = new SqlConnection(builder.ToString()))
            {
                connection.Open();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText =
                        @"
SELECT 
	l.Topic,
	l.Date,
	s.Name,
	t.Mark
FROM Attendance t
FULL OUTER JOIN Students s ON t.StudentName = s.Id
FULL OUTER JOIN Lecture l ON t.LectureDate = l.Id
ORDER BY l.Date";

                    var reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        Console.WriteLine($"{reader[0]} / {reader[1]} / {reader[2]} / {reader[3]}");
                    }

                    reader.Close();

                    Console.WriteLine("Iteration ended");
                }
            }
        }

        private static void Help() => Console.WriteLine($"Available commands are: {string.Join(" / ", Command.SupportedCommands)}. Every command must start with '-' prefix.");
        private static void ExecuteSQL(string text)
        {
            using (var connection = new SqlConnection(builder.ToString()))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = text;
                    command.ExecuteNonQuery();
                    Console.WriteLine("Complete");
                }
            }
        }
    }
}
