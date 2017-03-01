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

	
	//ָ������R��ָ�������Ĵ�����
	final int INSTRU_NUM = 30;
	final int R_INSTRU_NUM = 15;
	final int REG_NUM = 32;
	
	//ָ������Ƽ���Opcode
	final String INSTRU[] = {"nop","lw","sw","lui","add","addu","sub","subu",
			"addi","addiu","and","or","xor","nor","andi","sll","srl","sra","slt",
			"slti","sltiu","beq","bne","blez","bgtz","bltz","j","jal","jr","jalr"};
	final String INSTRU_OPCODE[] = {"000000","100011","101011","001111","000000","000000","000000","000000",
			"001000","001001","000000","000000","000000","000000","001100","000000","000000","000000","000000",
			"001010","001011","000100","000101","000110","000111","000001","000010","000011","000000","000000"};
	/*
	����ָ���ʽ�ֳ�10�����
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
	
	//R��ָ�����Ƽ���Funct
	final String R_INSTRU[] = {"nop","add","addu","sub","subu","and","or","xor","nor",
			"sll","srl","sra","slt","jr","jalr"};
	final String R_INSTRU_FUNCT[] = {"000000","100000","100001","100010","100011","100100",
			"100101","100110","100111","000000","000010","000011","101010","001000","001001"};
	
	//�Ĵ�����/���Ƽ���Ӧ�ļĴ�����ַ
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
		//�ؼ���--ָ�����ƣ�ֵ--ָ���Opcode�������뵽Map����OPCODE��
		for (int i = 0 ; i < INSTRU_NUM ; ++i)
		{
			Opcode.put(INSTRU[i], INSTRU_OPCODE[i]);
		}
		//�ؼ���--ָ�����ƣ�ֵ--ָ�����ͣ������뵽Map����Type��
		for (int i = 0 ; i < INSTRU_NUM ; ++i)
		{
			Type.put(INSTRU[i], CATEGORY[i]);
		}
		//�ؼ���--R��ָ�����ƣ�ֵ--ָ���Funct�������뵽Map����Funct��
		for (int i = 0 ; i < R_INSTRU_NUM ; ++i)
		{
			Funct.put(R_INSTRU[i], R_INSTRU_FUNCT[i]);
		}
		//�ؼ���--�Ĵ����ţ�ֵ--�Ĵ����ĵ�ַ�������뵽Map����RegCode��
		for (int i = 0 ; i < REG_NUM ; ++i)
		{
			RegCode.put(REGISTER[i], REGISTER_ADDRESS[i]);
		}
		//�ؼ���--�Ĵ������ƣ�ֵ--�Ĵ����ĵ�ַ�������뵽Map����RegCode��
		for (int i = 0 ; i < REG_NUM ; ++i)
		{
			RegCode.put(REGISTER[i + REG_NUM], REGISTER_ADDRESS[i]);
		}
	}
	
	public void complierMIPS()
	{
		//��MIPS�������Ԥ����
		try
		{
			//��MIPS�����ļ����룬�����ļ��������Ԥ�����MIPS����
			BufferedReader in = new BufferedReader(new FileReader(MIPS_fileName));
			BufferedWriter out = new BufferedWriter(new FileWriter(preCompiledFileName));
			//Ԥ����ȥ���ո��С�ע�͡���β�ո�
			String inLine;
			while((inLine = in.readLine())!=null)
			{
				
				inLine = inLine.replaceAll("#.*$" , "");			//ȥ��ע��
				if (inLine.matches("^\\s*$"))						//ƥ��ո��У�ֱ�Ӻ��Ե�
				{
					continue;
				}
				else
				{
					inLine = inLine.trim();							//ȥ����β�Ŀո�
					out.write(inLine);
					out.newLine();
				}
			}
			in.close();
			out.close();
		}
		catch(IOException iox)
		{
			JOptionPane.showMessageDialog(null,"Ԥ����ʱ�����ļ�����");
		}
		//�ؼ��� -- ��ǩ����ֵ -- ��ǩ��Ӧ�ĵ�ַ�������뵽Map����LabelAddress��ȥ
		try
		{
			BufferedReader in = new BufferedReader(new FileReader(preCompiledFileName));
			int LabelPosition = 0;
			int colonIndex;
			String inLine;
			String labelName;
			while((inLine = in.readLine())!=null)
			{
				colonIndex = inLine.indexOf(":");					//��ȡð�ŵ�����
				if(colonIndex != -1)								//����ð�ţ�˵���б�ǩ
				{
					labelName = inLine.substring(0,colonIndex);		//��ǩ����
					LabelAddress.put(labelName, LabelPosition);		//��ǩ�������ؼ��֣���ǩ��ַ��ֵ
					if(colonIndex != inLine.length() - 1)			//�����б�ǩ����ָ�λ�ü�һ
					{
						++LabelPosition;
					}
				}
				else												//������ð�ţ�˵���ޱ�ǩ��ֻ��һ��ָ�λ�ü�һ
				{
					++LabelPosition;
				}
			}
			in.close();
		}
		catch(IOException iox)
		{
			JOptionPane.showMessageDialog(null,"�м䲽������ļ�ʱ����");
		}
		//��ָ�����ɻ�����
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
				if(colonIndex == inLine.length() - 1)				//ֻ�б�ǩ
				{
					continue;
				}
				else
				{
					out.write(address+":	data <= 32'b");
					if(colonIndex != -1)							//�б�ǩҲ��ָ�ȥ����ǩ
					{
						inLine = (inLine.substring(colonIndex + 1,inLine.length())).trim();
					}
					spaceIndex = inLine.indexOf(" ");				//�ҳ��ո�λ��
					if(spaceIndex != -1)							//�пո��ҳ�ָ�����ƣ���ֳ�ָ�����ƺ���Ĳ���
					{
						instruName = inLine.substring(0,spaceIndex);
						restInstru = inLine.substring(spaceIndex,inLine.length());
						instruName = instruName.toLowerCase();		//תΪСд
					}
					else											//û�пո�˵����nopָ��
					{
						out.write("00000000000000000000000000000000;");
						out.newLine();
						++address;
						continue;
					}
					instruType = Type.get(instruName);
					String machineCode = Opcode.get(instruName);	//������ĵ�һ������Opcode
					switch(instruType)
					{
					case(1):										//1 -- lw,sw
					{												//lw rt,address
						String[] rest1 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rt = rest1[0].trim();				//��һ����($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
						String[] secondPart = rest1[1].split("[(]");//���������Ž��ڶ�����(offset($rs))�ٷֳ�������
						String offset = secondPart[0].trim();		//ƫ����offset
						String rs = (secondPart[1].split("[)]"))[0].trim();
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
						//Opcode|rs|rt|offset
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						//�����offset��������ҪתΪ16λ�Ķ�������
						String bin = Integer.toBinaryString(Integer.valueOf(offset));
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(2):										//lui
					{												//lui rt,imm
						String[] rest2 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rt = rest2[0].trim();				//��һ����($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
						String imm = rest2[1].trim();				//������imm
						//Opcode|0|rt|imm
						machineCode += "00000";
						machineCode += RegCode.get(rt);
						//�����imm��������ҪתΪ16λ�Ķ�������
						if(imm.substring(0, 2).equals("0x"))		//�����16����������תΪ10������
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
						String[] rest3 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rd = rest3[0].trim();				//��һ����($rd)
						rd = rd.substring(1, rd.length());			//�Ĵ���$rd
						String rs = rest3[1].trim();				//�ڶ�����($rs)
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
						String rt = rest3[2].trim();				//��������($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
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
						String[] rest4 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rt = rest4[0].trim();				//��һ����($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
						String rs = rest4[1].trim();				//�ڶ�����($rs)
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
						String imm = rest4[2].trim();				//��������(imm)
						if(imm.length()>2)
						{
							if(imm.substring(0, 2).equals("0x"))		//�����16����������תΪ10������
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
						String[] rest5 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rd = rest5[0].trim();				//��һ����($rd)
						rd = rd.substring(1, rd.length());			//�Ĵ���$rd
						String rt = rest5[1].trim();				//�ڶ�����($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
						String shamt = rest5[2].trim();				//��������(shamt)
						shamt = shamt.substring(0, shamt.length());	//��λ��shamt
						//Opcode|rs|rt|rd|shamt|funct
						machineCode += "00000";						//rs�ֶ�û�õ�������Ϊ0
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
						String[] rest6 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rs = rest6[0].trim();				//��һ����($rs)
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
						String rt = rest6[1].trim();				//�ڶ�����($rt)
						rt = rt.substring(1, rt.length());			//�Ĵ���$rt
						String label = rest6[2].trim();				//��������(��ǩlabel)
						//Opcode|rs|rt|offset
						machineCode += RegCode.get(rs);
						machineCode += RegCode.get(rt);
						//�����label����Ҫ����ƫ����
						int offset = LabelAddress.get(label) - (address + 1);
						String bin = Integer.toBinaryString(offset);
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(7):										//blez,bgtz,bltz
					{												//blez rs,label
						String[] rest7 = restInstru.split(",");		//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rs = rest7[0].trim();				//��һ����($rs)
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
						String label = rest7[1].trim();				//�ڶ�����(��ǩlabel)
						//Opcode|rs|0|offset
						machineCode += RegCode.get(rs);
						machineCode += "00000";
						//�����label����Ҫ����ƫ����
						int offset = LabelAddress.get(label) - (address + 1);
						String bin = Integer.toBinaryString(offset);
						if(bin.length()>16)
							bin = bin.substring(bin.length()-16,bin.length());
						machineCode += bin.format("%16s", bin).replace(" ", "0");
						break;
					}
					case(8):										//j,jal
					{												//j target
						String target = restInstru.trim();			//Ŀ��ָ��target
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
						String[] rest10 = restInstru.split(",");	//���ݶ��Ž�ʣ�µĲ��ֳַ���������
						String rd = rest10[0].trim();				//��һ����($rd)
						rd = rd.substring(1, rd.length());			//�Ĵ���$rd
						String rs = rest10[1].trim();				//�ڶ�����($rs)
						rs = rs.substring(1, rs.length());			//�Ĵ���$rs
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
			JOptionPane.showMessageDialog(null,"����ʱ����");
		}
	}
}
