package org.swizframework.metadata
{
   import org.swizframework.core.ISwiz;
   import org.swizframework.reflection.ClassConstant;
   import org.swizframework.reflection.Constant;
   import org.swizframework.reflection.TypeCache;
   import org.swizframework.reflection.TypeDescriptor;
   
   public class EventTypeExpression
   {
      
      protected var swiz:ISwiz;
      
      protected var expression:String;
      
      protected var _eventClass:Class;
      
      [ArrayElementType("String")]
      protected var _eventTypes:Array;
      
      public function EventTypeExpression(expression:String, swiz:ISwiz)
      {
         super();
         this.swiz = swiz;
         this.expression = expression;
         this.parse();
      }
      
      public function get eventClass() : Class
      {
         return this._eventClass;
      }
      
      [ArrayElementType("String")]
      public function get eventTypes() : Array
      {
         return this._eventTypes;
      }
      
      protected function parse() : void
      {
         var td:TypeDescriptor = null;
         var constant:Constant = null;
         if(this.swiz.config.strict && ClassConstant.isClassConstant(this.expression))
         {
            this._eventClass = ClassConstant.getClass(this.swiz.domain,this.expression,this.swiz.config.eventPackages);
            if(this.expression.substr(-2) == ".*")
            {
               td = TypeCache.getTypeDescriptor(this._eventClass,this.swiz.domain);
               this._eventTypes = new Array();
               for each(constant in td.constants)
               {
                  this._eventTypes.push(constant.value);
               }
            }
            else
            {
               this._eventTypes = [ClassConstant.getConstantValue(this.swiz.domain,this._eventClass,ClassConstant.getConstantName(this.expression))];
            }
         }
         else
         {
            this._eventClass = null;
            this._eventTypes = [this.expression];
         }
      }
   }
}

