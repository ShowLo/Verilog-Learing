package complier;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.swing.JOptionPane;

public class Compiler 
{
	String MIPS_fileName;
	String preCompiledFileName = "preCompiledCode.txt";
	String compiledFileName = "machineCode.txt";

	
	//指令数，R型指令数，寄存器数
	final int INSTRU_NUM = 30;
	final int R_INSTRU_NUM = 15;
	final int REG_NUM = 32;
	
	//指令的名称及其Opcode
	final String INSTRU[] = {"nop","lw","sw","lui","add","addu","sub","subu",
			"addi","addiu","and","or","xor","nor","andi","sll","srl","sra","slt",
			"slti","sltiu","beq","bne","blez","bgtz","bltz","j","jal","jr","jalr"};
	final String INSTRU_OPCODE[] = {"000000","100011","101011","001111","000000","000000","000000","000000",
			"001000","001001","000000","000000","000000","000000","001100","000000","000000","000000","000000",
			"001010","001011","000100","000101","000110","000111","000001","000010","000011","000000","000000"};
	/*
	根据指令格式分成10个类别
	0 -- nop
	1 -- lw,sw
	2 -- lui
	3 -- add,addu,sub,subu,and,or,xor,nor,slt
	4 -- addi,addiu,andi,slti,sltiu
	5 -- sll,srl,sra
	6 -- beq,bne
	7 -- blez,bgtz,bltz
	8 -- j,jal
	9 -- jr
	10 -- jalr
	*/
	final int CATEGORY[] = {0,1,1,2,3,3,3,3,4,4,3,3,3,3,4,5,5,5,3,4,4,6,6,7,7,7,8,8,9,10};
	
	//R型指令名称及其Funct
	final String R_INSTRU[] = {"nop","add","addu","sub","subu","and","or","xor","nor",
			"sll","srl","sra","slt","jr","jalr"};
	final String R_INSTRU_FUNCT[] = {"000000","100000","100001","100010","100011","100100",
			"100101","100110","100111","000000","000010","000011","101010","001000","001001"};
	
	//寄存器号/名称及对应的寄存器地址
	final String REGISTER[] = {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14",
			"15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31",
			"zero","at","v0","v1","a0","a1","a2","a3","t0","t1","t2","t3","t4","t5","t6","t7",
			"s0","s1","s2","s3","s4","s5","s6","s7","t8","t9","k0","k1","gp","sp","fp","ra"};
	final String REGISTER_ADDRESS[] = {"00000","00001","00010","00011","00100","00101","00110","00111",
			"01000","01001","01010","01011","01100","01101","01110","01111","10000","10001","10010","10011",
			"10100","10101","10110","10111","11000","11001","11010","11011","11100","11101","11110","11111"};
	Map<String,String> Opcode = new HashMap<String,String>();
	Map<String,Integer> Type = new HashMap<String,Integer>();
	Map<String,String> Funct = new HashMap<String,String>();
	Map<String,String> RegCode = new HashMap<String,String>();
	Map<String,Integer> LabelAddress = new HashMap<String,Integer>();
	
	public Compiler(String MIPS_fileName)
	{
		this.MIPS_fileName = MIPS_fileName;
		//关键字--指令名称，值--指令的Opcode，并加入到Map对象OPCODE中
		for (int i = 0 ; i < INSTRU_NUM ; ++i)
		{
			Opcode.put(INSTRU[i], INSTRU_OPCODE[i]);
		}
		//关键字--指令名称，值--指令类型，并加入到Map对象Type中
		for (int i = 0 ; i < INSTRU_NUM ; ++i)
		{
			Type.put(INSTRU[i], CATEGORY[i]);
		}
		//关键字--R型指令名称，值--指令的Funct，并加入到Map对象Funct中
		for (int i = 0 ; i < R_INSTRU_NUM ; ++i)
		{
			Funct.put(R_INSTRU[i], R_INSTRU_FUNCT[i]);
		}
		//关键字--寄存器号，值--寄存器的地址，并加入到Map对象RegCode中
		for (int i = 0 ; i < REG_NUM ; ++i)
		{
			RegCode.put(REGISTER[i], REGISTER_ADDRESS[i]);
		}
		//关键字--寄存器名称，值--寄存器的地址，并加入到Map对象RegCode中
		for (int i = 0 ; i < REG_NUM ; ++i)
		{
			RegCode.put(REGISTER[i + REG_NUM], REGISTER_ADDRESS[i]);
		}
	}
	
	public void complierMIPS()
	{
		//对MIPS代码进行预处理
		try
		{
			//打开MIPS代码文件读入，创建文件输出经过预处理的MIPS代码
			BufferedReader in = new BufferedReader(new FileReader(MIPS_fileName));
			BufferedWriter out = new BufferedWriter(new FileWriter(preCompiledFileName));
			//预处理，去除空格行、注释、首尾空格
			String inLine;
			while((inLine = in.readLine())!=null)
			{
				
				inLine = inLine.replaceAll("#.*$" , "");			//去掉注释
				if (inLine.matches("^\\s*$"))						//匹配空格行，直接忽略掉
				{
					continue;
				}
				else
				{
					inLine = inLine.trim();							//去掉首尾的空格
					out.write(inLine);
					out.newLine();
				}
			}
			in.close();
			out.close();
		}
		catch(IOException iox)
		{
			JOptionPane.showMessageDialog(null,"预处理时操作文件出错");
		}
		//关键字 -- 标签名，值 -- 标签对应的地址，并加入到Map对象LabelAddress中去
		try
		{
			BufferedReader in = new BufferedReader(new FileReader(preCompiledFileName));
			int LabelPosition = 0;
			int colonIndex;
			String inLine;
			String labelName;
			while((inLine = in.readLine())!=null)
			{
				colonIndex = inLine.indexOf(":");					//获取冒号的索引
				if(colonIndex != -1)								//存在冒号，说明有标签
				{
					labelName = inLine.substring(0,colonIndex);		//标签名称
					LabelAddress.put(labelName, LabelPosition);		//标签名称作关键字，标签地址作值
					if(colonIndex != inLine.length() - 1)			//不仅有标签还有指令，位置加一
					{
						++LabelPosition;
					}
				}
				else												//不存在冒号，说明无标签而只是一条指令，位置加一
				{
					++LabelPosition;
				}
			}
			in.close();
		}
		catch(IOException iox)
		{
			JOptionPane.showMessageDialog(null,"中间步骤操作文件时出错");
		}
		//把指令编译成机器码
		try
		{
			BufferedReader in = new BufferedReader(new FileReader(preCompiledFileName));
			BufferedWriter out = new BufferedWriter(new FileWriter(compiledFileName));
			int colonIndex;
			int spaceIndex;
			int address = 0;
			int instruType;
			String inLine;
			String instruName;
			String restInstru;
			String instruOpcode;
			while((inLine = in.readLine())!=null)
			{
				colonIndex = inLine.indexOf(":");
				if(colonIndex == inLine.length() - 1)				//只有标签
				{
					continue;
				}
				else
				{
					out.write(address+":	data <= 32'b");
					if(colonIndex != -1)							//有标签也有指令，去除标签
					{
						inLine = (inLine.substring(colonIndex + 1,inLine.length())).trim();
					}
					spaceIndex = inLine.indexOf(" ");				//找出空格位置
					if(spaceIndex != -1)							//有空格，找出指令名称，拆分出指令名称后面的部分
					{
						instruName = inLine.substring(0,spaceIndex);
						restInstru = inLine.substring(spaceIndex,inLine.length());
						instruName = instruName.toLowerCase();		//转为小写
					}
					else											//没有空格说明是nop指令
					{
						out.write("00000000000000000000000000000000;");
						out.newLine();
						++address;
						continue;
					}
					instruType = Type.get(instruName);
					String machineCode = Opcode.get(instruName);	//机器码的第一部分是Opcode
					switch(instruType)
					{
					case(1):										//1 -- lw,sw
					{												//lw rt,address
						String[] rest1 = restInstru.split(",");		//根据逗号将剩下的部分分成两个部分
						String rt = rest1[0].trim();				//第一部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						String[] secondPart = rest1[1].split("[(]");//根据左括号将第二部分(offset($rs))再分成两部分
						String offset = secondPart[0].trim();		//偏移量offset
						String rs = (secondPart[1].split("[)]"))[0].trim();
						rs = rs.substring(1, rs.length());			//寄存器$rs
						//Opcode|rs|rt|offset
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						//最后是offset，但首先要转为16位的二进制码
						String bin = Integer.toBinaryString(Integer.valueOf(offset));
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(2):										//lui
					{												//lui rt,imm
						String[] rest2 = restInstru.split(",");		//根据逗号将剩下的部分分成两个部分
						String rt = rest2[0].trim();				//第一部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						String imm = rest2[1].trim();				//立即数imm
						//Opcode|0|rt|imm
						machineCode += "00000";
						machineCode += RegCode.get(rt);
						//最后是imm，但首先要转为16位的二进制码
						if(imm.substring(0, 2).equals("0x"))		//如果是16进制数，先转为10进制数
						{
							String realHex = imm.substring(2,imm.length());
							imm = String.valueOf((Integer.parseInt(realHex, 16)));
						}
						String bin = Integer.toBinaryString(Integer.valueOf(imm));
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(3):										//add,addu,sub,subu,and,or,xor,nor,slt
					{												//add rd,rs,rt
						String[] rest3 = restInstru.split(",");		//根据逗号将剩下的部分分成三个部分
						String rd = rest3[0].trim();				//第一部分($rd)
						rd = rd.substring(1, rd.length());			//寄存器$rd
						String rs = rest3[1].trim();				//第二部分($rs)
						rs = rs.substring(1, rs.length());			//寄存器$rs
						String rt = rest3[2].trim();				//第三部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						//Opcode|rs|rt|rd|0|funct
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						machineCode += RegCode.get(rd);
						machineCode += "00000";
						machineCode += Funct.get(instruName);
						break;
					}
					case(4):										//addi,addiu,andi,slti,sltiu
					{												//addi rt,rs,imm
						String[] rest4 = restInstru.split(",");		//根据逗号将剩下的部分分成三个部分
						String rt = rest4[0].trim();				//第一部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						String rs = rest4[1].trim();				//第二部分($rs)
						rs = rs.substring(1, rs.length());			//寄存器$rs
						String imm = rest4[2].trim();				//第三部分(imm)
						if(imm.length()>2)
						{
							if(imm.substring(0, 2).equals("0x"))		//如果是16进制数，先转为10进制数
							{
								String realHex = imm.substring(2,imm.length());
								imm = String.valueOf((Integer.parseInt(realHex, 16)));
							}
						}
						//Opcode|rs|rt|imm
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						String bin = Integer.toBinaryString(Integer.valueOf(imm));
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(5):										//sll,srl,sra
					{
						String[] rest5 = restInstru.split(",");		//根据逗号将剩下的部分分成三个部分
						String rd = rest5[0].trim();				//第一部分($rd)
						rd = rd.substring(1, rd.length());			//寄存器$rd
						String rt = rest5[1].trim();				//第二部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						String shamt = rest5[2].trim();				//第三部分(shamt)
						shamt = shamt.substring(0, shamt.length());	//移位量shamt
						//Opcode|rs|rt|rd|shamt|funct
						machineCode += "00000";						//rs字段没用到，设置为0
						machineCode += RegCode.get(rt);
						machineCode += RegCode.get(rd);
						String bin = Integer.toBinaryString(Integer.valueOf(shamt));
						if(bin.length()>5)
							bin = bin.substring(bin.length()-5,bin.length());
						machineCode += bin.format("%5s", bin).replace(" ", "0");
						machineCode += Funct.get(instruName);
						break;
					}
					case(6):										//beq,bne
					{												//beq rs,rt,label
						String[] rest6 = restInstru.split(",");		//根据逗号将剩下的部分分成三个部分
						String rs = rest6[0].trim();				//第一部分($rs)
						rs = rs.substring(1, rs.length());			//寄存器$rs
						String rt = rest6[1].trim();				//第二部分($rt)
						rt = rt.substring(1, rt.length());			//寄存器$rt
						String label = rest6[2].trim();				//第三部分(标签label)
						//Opcode|rs|rt|offset
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						//最后是label，需要计算偏移量
						int offset = LabelAddress.get(label) - (address + 1);
						String bin = Integer.toBinaryString(offset);
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(7):										//blez,bgtz,bltz
					{												//blez rs,label
						String[] rest7 = restInstru.split(",");		//根据逗号将剩下的部分分成两个部分
						String rs = rest7[0].trim();				//第一部分($rs)
						rs = rs.substring(1, rs.length());			//寄存器$rs
						String label = rest7[1].trim();				//第二部分(标签label)
						//Opcode|rs|0|offset
						machineCode += RegCode.get(rs);
						machineCode += "00000";
						//最后是label，需要计算偏移量
						int offset = LabelAddress.get(label) - (address + 1);
						String bin = Integer.toBinaryString(offset);
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(8):										//j,jal
					{												//j target
						String target = restInstru.trim();			//目标指令target
						//Opcode|target
						int targetAddress = LabelAddress.get(target);
						String bin = Integer.toBinaryString(targetAddress);
						if(bin.length()>26)
							bin = bin.substring(bin.length()-26,bin.length());
						machineCode += bin.format("%26s", bin).replace(" ", "0");
						break;
					}
					case(9):										//jr
					{												//jr rs
						String rs = restInstru.trim();				//$rs
						rs = rs.substring(1, rs.length());
						//Opcode|rs|0|funct
						machineCode += RegCode.get(rs);
						machineCode += "000000000000000";
						machineCode += Funct.get(instruName);
						break;
					}
					case(10):										//jalr
					{												//jalr rd,rs
						String[] rest10 = restInstru.split(",");	//根据逗号将剩下的部分分成两个部分
						String rd = rest10[0].trim();				//第一部分($rd)
						rd = rd.substring(1, rd.length());			//寄存器$rd
						String rs = rest10[1].trim();				//第二部分($rs)
						rs = rs.substring(1, rs.length());			//寄存器$rs
						//Opcode|rs|0|rd|0|funct
						machineCode += RegCode.get(rs);
						machineCode += "00000";
						machineCode += RegCode.get(rd);
						machineCode += "00000";
						machineCode += Funct.get(instruName);
						break;
					}
					}			
					machineCode += ";";
					out.write(machineCode);
					out.newLine();
					++address;
				}
			}
			in.close();
			out.close();
			File file = new File(preCompiledFileName);
			file.delete();
		}
		catch(Exception e)
		{
			JOptionPane.showMessageDialog(null,"编译时出错");
		}
	}
}
