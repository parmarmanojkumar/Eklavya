/*


Lessons:
- Avoid reentrant code where possible because the SRAM is pretty tight and it is easy to run out, overwrite part of the stack, and fail mysteriously. 
- BNO055 with Due is weird, It saturates if plugged in for more than 5 mins

  
 
*/
