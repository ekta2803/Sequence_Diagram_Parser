

public aspect TracingAspect {

	private String signature = "";
	private String[] strArray;
	private String currentClass = "ObserverTest";
	private String previousClass = "";
	private String targetClass = "";
	private String methodName = "";
	private String returnType = "";
	private int observerFlag = 0;

	
	
	pointcut whatIDontWant() :  within(TracingAspect) ||
								call(* java..*.*(..)) ||
								call(* *.setUp(..)) ||
								call(* *.tearDown(..));
								
	
	pointcut whatIWant()     : call(* *.*(..));
	pointcut allIWant()      : whatIWant() && !whatIDontWant();
	

	before() : initialization(*.new(..)) && within(TheEconomy) {
		
		String className = thisJoinPointStaticPart.getSignature().toString();
		className = className.split("\\(")[0];
		ObserverTest.finalString = ObserverTest.finalString + "@found '" + currentClass + "',->%0A";
		ObserverTest.finalString = ObserverTest.finalString + "  @create '" + className + "',%0A";
	}
	
	before() : initialization(*.new(..)) && within(Optimist) {
		//for optimist class
		String className = thisJoinPointStaticPart.getSignature().toString();
		className = className.split("\\(")[0];
		ObserverTest.finalString = ObserverTest.finalString + "@found '" + currentClass + "',->%0A";
		ObserverTest.finalString = ObserverTest.finalString + "  @create '" + className + "',%0A";     
	}
	
	before() : initialization(*.new(..)) && within(Pessimist) {
		//for pessimist class
		String className = thisJoinPointStaticPart.getSignature().toString();
		className = className.split("\\(")[0];
		ObserverTest.finalString = ObserverTest.finalString + "@found '" + currentClass + "',->%0A";
		ObserverTest.finalString = ObserverTest.finalString +	"  @create '" + className + "',%0A";     
	}
	  
	before() : allIWant() {
		signature = thisJoinPoint.getSignature().toString();
		currentClass = thisJoinPoint.getThis().getClass().getName();
		strArray = signature.split("[\\s\\.]+");
		returnType = strArray[0];
		targetClass = strArray[1];
		methodName = strArray[2];
		methodName = methodName + ":" + returnType;
		
		if(currentClass.equals("ConcreteSubject")) currentClass = "TheEconomy";
		if(targetClass.equals("ConcreteSubject")) targetClass = "TheEconomy";
		if(targetClass.equals("Observer")) {
			if(observerFlag == 1){
				targetClass = "Optimist";
				observerFlag = 0;
			}else{
				targetClass = "Pessimist";
				observerFlag = 1;
			}
		}
		
		
		if(!currentClass.equals(previousClass)){
			ObserverTest.finalString = ObserverTest.finalString + "@found '" + currentClass + "',->%0A";
		}
		
		ObserverTest.finalString = ObserverTest.finalString + "  @message '" + methodName + "', '" + targetClass +"',->%0A";
		previousClass = currentClass;

	}
	
	
	
}