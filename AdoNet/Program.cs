namespace AdoNet
{
    using System;
    using System.Linq;

    static class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Write cs.exe -help to get information");
                return;
            }

            if (!args[0].StartsWith("-"))
            {
                Console.WriteLine("All commands must start with '-' character");
                return;
            }

            args[0] = args[0].Substring(1);
            if (!Command.SupportedCommands.Contains(args[0]))
            {
                Console.WriteLine($"{args[0]} is not supported. Check sc -help to get information");
                return;
            }

            try
            {
                new Command(args[0], args.Skip(1).ToArray());
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
