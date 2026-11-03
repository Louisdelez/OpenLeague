package hr.binaria.asx3m.annotations
{
   public class Annotation
   {
      
      private var m_name:String;
      
      private var m_holder:String;
      
      private var m_value:String;
      
      public function Annotation(param1:String, param2:String, param3:String)
      {
         super();
         this.m_holder = param1;
         this.m_name = param2;
         this.m_value = param3;
      }
      
      public function set value(param1:String) : void
      {
         this.m_value = param1;
      }
      
      public function get name() : String
      {
         return m_name;
      }
      
      public function get holder() : String
      {
         return m_holder;
      }
      
      public function get value() : String
      {
         return m_value;
      }
      
      public function set name(param1:String) : void
      {
         this.m_name = param1;
      }
      
      public function set holder(param1:String) : void
      {
         this.m_holder = param1;
      }
   }
}

