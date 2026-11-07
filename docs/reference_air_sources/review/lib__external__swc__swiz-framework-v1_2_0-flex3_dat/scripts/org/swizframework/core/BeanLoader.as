package org.swizframework.core
{
   import org.swizframework.utils.logging.SwizLogger;
   
   public class BeanLoader extends BeanProvider
   {
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      public function BeanLoader(beans:Array = null)
      {
         super(beans);
         this.logger.warn("BeanLoader is deprecated! Please refactor your loaders to BeanProvider as this class will be removed eventually!");
      }
   }
}

