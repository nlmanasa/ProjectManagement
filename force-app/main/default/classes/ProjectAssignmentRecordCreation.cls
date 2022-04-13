public with Sharing class ProjectAssignmentRecordCreation {
    public  Static void createProAssRecord(List<Project__c> projectList) {
        List<Project_Assignment__c> CreatePArecord = new List<Project_Assignment__c>();
        List<Employee__c> getEmployees = [Select Id , name  from  Employee__c where Employee_Status__c ='Unassigned'];
        Integer count1 = 0;
        for(Project__c pcc :projectList) {
            if(pcc.Project_Stage__c == 'Draft' && getEmployees.size()>pcc.Employees_Required__c){
                Integer count = 0;
                
                while(count< pcc.Employees_Required__c){
                    Project_Assignment__c PArec = new Project_Assignment__c();
                    PArec.Project_Name__c =  pcc.Id;
                    PArec.Project_Start_Date__c = pcc.Project_Start_Date__c;
                    PArec.Roll_off_Date__c = pcc.Project_End_Date__c;
                    PArec.Employee_Name__c =  getEmployees.get(count1).Id;
                    CreatePArecord.add(PArec);
                    count1++;
                    count++;
                }
            }
            
        }
        insert CreatePArecord;
     }
   public static void updatedata(List<Project__c> getProjectRecords) {
        List<Project_Assignment__c> getPArecord = [Select Id, Name,Project_Name__c, Employee_Name__c, Employee_Name__r.name, Employee_Name__r.Employee_Status__c from
                                                   Project_Assignment__c where Project_Name__c IN :getProjectRecords ];
       List<Employee__c> emp= new List<Employee__c>();
       for(Project_Assignment__c pr : getPArecord){
          emp.add(new Employee__c(Id = pr.Employee_Name__c));  
          }
         
        
       List<Employee__c> employee =[SELECT Id, Name, Employee_Status__c, Email__c
                FROM Employee__c WHERE Id IN: emp AND Employee_Status__c = 'Assigned'
            ];
         for (Employee__c em: employee) {
                List < String > emailIds = new List < String > ();
                List < Messaging.SingleEmailMessage > emailList = new List < Messaging.SingleEmailMessage > ();
                emailIds.add(em.Email__c);
                if (em.Email__c != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName('Stratos');
                    mail.setSubject('Successfull Completion of project');
                    mail.setHtmlBody('Dear ' + em.Name + ', <br/>' + 'I just wanted to thank you for the' 
                                     +'time you put in for our project. We were happy to have you on our team and'
                                     + ' look forward to seeing you again.<br/><br/>'
                                  +'Thank you!'  );
                    mail.toAddresses = new String[] {
                        em.Email__c
                    };
                    emailList.add(mail);
                }
 
                if (emailList.size() > 0) {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
                   

                }
         }
       
       For(Employee__c em : emp){
           em.Employee_Status__c = 'Unassigned';
       }
       update emp;
    }
    
}