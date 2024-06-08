//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;

//namespace WindowsFormsApplicationGUIuARM
//{
//    class FamiliesRepresentatives
//    {
//        private string representativeId;
//        private string Address;
//        private string firstName;
//        private string lastName;
//        private bool isActive;
    
//    public FamiliesRepresentatives(string representativeId, string Address, string firstName, string lastName, bool isActive, bool is_new)
//    {
//        this.representativeId = representativeId;
//        this.Address = Address;
//        this.firstName = firstName;
//        this.lastName = lastName;
//        this.isActive = isActive;
//        if (is_new)
//        {
//            this.CreateFamiliesRepresentatives();
//            Program.FamiliesRepresentatives.Add(this);
//        }
//    }
//    public void CreateFamiliesRepresentatives()
//    {
//        SqlCommand command = new SqlCommand();
//        command.CommandText = "INSERT INTO Representatives (RepresentativeId, Address, FirstName, LastName, IsActive) " +
//                              "VALUES (@RepresentativeId, @Address, @FirstName, @LastName, @IsActive)";
//        command.Parameters.AddWithValue("@RepresentativeId", this.representativeId);
//        command.Parameters.AddWithValue("@Address", this.Address);
//        command.Parameters.AddWithValue("@FirstName", this.firstName);
//        command.Parameters.AddWithValue("@LastName", this.lastName);
//        command.Parameters.AddWithValue("@IsActive", this.isActive);

//        SQL_CON connection = new SQL_CON();
//        connection.execute_non_query(command);
//    }
//        public void UpdateFamiliesRepresentatives(string familyId, string newRepresentativeId)
//        {
//            SqlCommand command = new SqlCommand();
//            command.CommandText = "UPDATE Families SET RepresentativeId = @NewRepresentativeId " +
//                                  "WHERE FamilyId = @FamilyId";
//            command.Parameters.AddWithValue("@NewRepresentativeId", newRepresentativeId);
//            command.Parameters.AddWithValue("@FamilyId", familyId);

//            SQL_CON connection = new SQL_CON();
//            connection.execute_non_query(command);
//        }
//    }
