package hr.binaria.asx3m.annotations
{
   import system.data.Iterator;
   import system.data.lists.ArrayList;
   
   public class Annotated
   {
      
      private var m_fieldAnnotations:ArrayList;
      
      private var m_classAnnotations:ArrayList;
      
      public function Annotated()
      {
         super();
         m_fieldAnnotations = new ArrayList();
         m_classAnnotations = new ArrayList();
      }
      
      public function getClassAnnotation(param1:String) : Annotation
      {
         var _loc2_:Annotation = null;
         var _loc3_:Iterator = m_classAnnotations.iterator();
         while(_loc3_.hasNext())
         {
            _loc2_ = _loc3_.next();
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFieldAnnotation(param1:String, param2:String) : Annotation
      {
         var _loc3_:Annotation = null;
         var _loc4_:Iterator = m_fieldAnnotations.iterator();
         while(_loc4_.hasNext())
         {
            _loc3_ = _loc4_.next();
            if(_loc3_.holder == param1 && _loc3_.name == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function get classAnnotations() : ArrayList
      {
         return m_classAnnotations;
      }
      
      public function addClassAnnotation(param1:Annotation) : void
      {
         m_classAnnotations.add(param1);
      }
      
      public function get fieldAnnotations() : ArrayList
      {
         return m_fieldAnnotations;
      }
      
      public function addFieldAnnotation(param1:Annotation) : void
      {
         m_fieldAnnotations.add(param1);
      }
   }
}

