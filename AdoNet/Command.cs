namespace AdoNet
{
    using System;

    public class Command
    {
        public static string[] SupportedCommands = { "init", "lecture", "student", "attend", "report", "help" };

        private string[] attributeNames;

        public Command(string name, params string[] attributes)
        {
            MakeAttributes(name);

            if(attributeNames.Length != attributes.Length)
            {
                throw new ArgumentOutOfRangeException($"Wrong amount of attributes. It must be written like '-{name} {string.Join(" ", attributeNames)}'");
            }

            var execute = new Executioner(name, attributes);
            if (!execute.TryExecute(out var exc))
            {
                throw exc;
            }
        }

        private void MakeAttributes(string name)
        {
            switch (name)
            {
                case "init":
                case "report":
                case "help":
                    attributeNames = new string[0];
                    break;

                case "lecture":
                    attributeNames = new string[] { "<DATE>", "<TOPIC>" };
                    break;

                case "student":
                    attributeNames = new string[] { "<NAME>" };
                    break;

                case "attend":
                    attributeNames = new string[] { "<STUDENT_NAME>", "<Topic>", "<MARK>" };
                    break;

                default:
                    throw new NotImplementedException();
            }
        }
    }
}
