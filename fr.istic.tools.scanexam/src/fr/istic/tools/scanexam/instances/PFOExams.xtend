package fr.istic.tools.scanexam.instances

import static fr.istic.tools.scanexam.utils.ScanExamXtendFactory.*

class PFOExams{
	
	def static olivier() {
		
		val students = #[
			"Olivier 1",
			"Olivier 2"
		]
		val e= exam(
			"ExamSir", 
			"/home/barais/workspaces/qrcodedetector/correctExam/src/main/resources/images/out/",
			2,
			"/home/barais/workspaces/qrcodedetector/correctExam/src/main/resources/images/out1/",
			students
/*			42,
			 #[
				question("NAME",#[X0,0,X1,800,1], #[30,80,80,60,0], students,0),
				question("EX1_Q1",#[X0,1200,X1,2900,1], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX1_Q2",#[X0,2700,X1,3250,1], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX1_Q3",#[X0,300,X1,950,2],  #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),

				question("EX2_Q1",#[X0,2100,X1,2600,2], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q2",#[X0,2600,X1,2950,2], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q3",#[X0,300,X1,2500,3], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q4",#[X0,2500,X1,3300,3], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q5",#[X0,450  ,X1,1000,4], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q6",#[X0,1000,X1,1500,4], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q7",#[X0,1550,X1,2400,4], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q8",#[X0,2500,X1,2900,4], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),
				question("EX2_Q9",#[X0,2800,X1,3250,4], #[30,80,80,60,0],  #["A", "B", "C", "D", "E", "F"],2),


				                                         
				question("EX3_Q1",#[X0,1300,X1,1500,5],  #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],2),
				question("EX3_Q2",#[X0,1500,X1,2100,5], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],2),
				question("EX3_Q3",#[X0,0,X1,3000,5], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],5)
			]
			  */
			
		)
		val weights = #[	
			0,
			/* EX1 : 14 */ 1,2,2,
			/* EX2 : 19 "*/ 1,6,3,6,2,2,2,9,10,
			/* EX3 : 13 */ 4,3,6
		];

		for(i:0..<e.questions.size) {
			e.questions.get(i).weight=weights.get(i)
		}
		e
	}
	def static december19() {
		val X0 = 100
		val X1 = 1200
		val e= exam(
			"PFO_december_19", 
			"/home/barais/workspaces/qrcodedetector/correctExam/src/main/resources/images/out/",
			2,
			42,
			 #[
				question("ID",#[0,0,1200,600,1], #[30,80,80,60,0], #["F", "A"],0 ),
				question("EX1_Q1",#[X0,600,X1,1200,1], #[30,80,80,60,0], #["A", "B", "C", "D", "E", "F"],0),
				question("EX1_Q2",#[X0,600,X1,1200,1], #[30,80,80,60,0], #["F", "C", "A"],0)
			]                                                       
		)
		val weights = #[	
			0,
			/* EX1 : 14 */ 1,2,2,2,2,4,1,
			/* EX2 : 19 "*/ 2,6,3,6,2,
			/* EX3 : 13 */ 4,3,6
		];

		for(i:0..<e.questions.size) {
			e.questions.get(i).weight=weights.get(i)
		}
		e                                                           
	} 
}