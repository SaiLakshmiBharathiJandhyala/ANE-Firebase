/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.firebase.database.MutableData;
	import com.distriqt.extension.firebase.database.transactions.TransactionHandler;
	import com.distriqt.extension.firebase.database.transactions.TransactionResult;
	
	
	/**	
	 *
	 */
	public class SimpleTransactionHandler implements TransactionHandler
	{
		
		public function doTransaction( mutableData:MutableData ):TransactionResult
		{
			var data:Object = mutableData.getValue();
			if (data == null)
			{
				mutableData.setValue("initial value");
				return TransactionResult.success(mutableData);
			}
			mutableData.setValue( "value from transaction "+String(Math.floor(Math.random()*1000)) );
			return TransactionResult.success(mutableData);
		}
		
	}
	
	
	
}