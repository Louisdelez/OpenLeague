package com.rational.utils
{
   public interface IProperty
   {
      
      function getType() : Class;
      
      function getName() : String;
      
      function getElementType() : Class;
      
      function getAccess() : String;
   }
}

