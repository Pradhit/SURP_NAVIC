
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MINRESRX2FFT_MEMSEL IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        btfOut1_re                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        btfOut1_im                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        btfOut2_re                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        btfOut2_im                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        btfOut_vld                        :   IN    std_logic;
        stage                             :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        initIC                            :   IN    std_logic;
        syncReset                         :   IN    std_logic;
        stgOut1_re                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        stgOut1_im                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        stgOut2_re                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        stgOut2_im                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        stgOut_vld                        :   OUT   std_logic
        );
END MINRESRX2FFT_MEMSEL;


ARCHITECTURE rtl OF MINRESRX2FFT_MEMSEL IS

  -- Signals
  SIGNAL btfOut1_re_signed                : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL btfOut1_im_signed                : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL btfOut2_re_signed                : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL btfOut2_im_signed                : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL stage_unsigned                   : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_re : signed(31 DOWNTO 0);  -- sfix32
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_im : signed(31 DOWNTO 0);  -- sfix32
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_re : signed(31 DOWNTO 0);  -- sfix32
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_im : signed(31 DOWNTO 0);  -- sfix32
  SIGNAL MINRESRX2FFTMEMSEL_stgOutReg_vld : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_cnt           : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL MINRESRX2FFTMEMSEL_cntMax        : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL MINRESRX2FFTMEMSEL_muxSel        : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_re_next : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_im_next : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_re_next : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_im_next : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL MINRESRX2FFTMEMSEL_stgOutReg_vld_next : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_cnt_next      : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL MINRESRX2FFTMEMSEL_cntMax_next   : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL MINRESRX2FFTMEMSEL_muxSel_next   : std_logic;
  SIGNAL stgOut1_re_tmp                   : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL stgOut1_im_tmp                   : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL stgOut2_re_tmp                   : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL stgOut2_im_tmp                   : signed(31 DOWNTO 0);  -- sfix32_En16

BEGIN
  btfOut1_re_signed <= signed(btfOut1_re);

  btfOut1_im_signed <= signed(btfOut1_im);

  btfOut2_re_signed <= signed(btfOut2_re);

  btfOut2_im_signed <= signed(btfOut2_im);

  stage_unsigned <= unsigned(stage);

  -- MINRESRX2FFTMEMSEL
  MINRESRX2FFTMEMSEL_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      MINRESRX2FFTMEMSEL_stgOut1Reg_re <= to_signed(0, 32);
      MINRESRX2FFTMEMSEL_stgOut1Reg_im <= to_signed(0, 32);
      MINRESRX2FFTMEMSEL_stgOut2Reg_re <= to_signed(0, 32);
      MINRESRX2FFTMEMSEL_stgOut2Reg_im <= to_signed(0, 32);
      MINRESRX2FFTMEMSEL_cnt <= to_unsigned(16#0000#, 14);
      MINRESRX2FFTMEMSEL_cntMax <= to_unsigned(16#0000#, 14);
      MINRESRX2FFTMEMSEL_muxSel <= '0';
      MINRESRX2FFTMEMSEL_stgOutReg_vld <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        IF syncReset = '1' THEN
          MINRESRX2FFTMEMSEL_stgOut1Reg_re <= to_signed(0, 32);
          MINRESRX2FFTMEMSEL_stgOut1Reg_im <= to_signed(0, 32);
          MINRESRX2FFTMEMSEL_stgOut2Reg_re <= to_signed(0, 32);
          MINRESRX2FFTMEMSEL_stgOut2Reg_im <= to_signed(0, 32);
          MINRESRX2FFTMEMSEL_cnt <= to_unsigned(16#0000#, 14);
          MINRESRX2FFTMEMSEL_cntMax <= to_unsigned(16#0000#, 14);
          MINRESRX2FFTMEMSEL_muxSel <= '0';
          MINRESRX2FFTMEMSEL_stgOutReg_vld <= '0';
        ELSE 
          MINRESRX2FFTMEMSEL_stgOut1Reg_re <= MINRESRX2FFTMEMSEL_stgOut1Reg_re_next;
          MINRESRX2FFTMEMSEL_stgOut1Reg_im <= MINRESRX2FFTMEMSEL_stgOut1Reg_im_next;
          MINRESRX2FFTMEMSEL_stgOut2Reg_re <= MINRESRX2FFTMEMSEL_stgOut2Reg_re_next;
          MINRESRX2FFTMEMSEL_stgOut2Reg_im <= MINRESRX2FFTMEMSEL_stgOut2Reg_im_next;
          MINRESRX2FFTMEMSEL_stgOutReg_vld <= MINRESRX2FFTMEMSEL_stgOutReg_vld_next;
          MINRESRX2FFTMEMSEL_cnt <= MINRESRX2FFTMEMSEL_cnt_next;
          MINRESRX2FFTMEMSEL_cntMax <= MINRESRX2FFTMEMSEL_cntMax_next;
          MINRESRX2FFTMEMSEL_muxSel <= MINRESRX2FFTMEMSEL_muxSel_next;
        END IF;
      END IF;
    END IF;
  END PROCESS MINRESRX2FFTMEMSEL_process;

  MINRESRX2FFTMEMSEL_output : PROCESS (MINRESRX2FFTMEMSEL_cnt, MINRESRX2FFTMEMSEL_cntMax, MINRESRX2FFTMEMSEL_muxSel,
       MINRESRX2FFTMEMSEL_stgOut1Reg_im, MINRESRX2FFTMEMSEL_stgOut1Reg_re,
       MINRESRX2FFTMEMSEL_stgOut2Reg_im, MINRESRX2FFTMEMSEL_stgOut2Reg_re,
       MINRESRX2FFTMEMSEL_stgOutReg_vld, btfOut1_im_signed, btfOut1_re_signed,
       btfOut2_im_signed, btfOut2_re_signed, btfOut_vld, initIC,
       stage_unsigned)
  BEGIN
    MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= MINRESRX2FFTMEMSEL_stgOut1Reg_re;
    MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= MINRESRX2FFTMEMSEL_stgOut1Reg_im;
    MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= MINRESRX2FFTMEMSEL_stgOut2Reg_re;
    MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= MINRESRX2FFTMEMSEL_stgOut2Reg_im;
    MINRESRX2FFTMEMSEL_cnt_next <= MINRESRX2FFTMEMSEL_cnt;
    MINRESRX2FFTMEMSEL_cntMax_next <= MINRESRX2FFTMEMSEL_cntMax;
    MINRESRX2FFTMEMSEL_muxSel_next <= MINRESRX2FFTMEMSEL_muxSel;
    IF MINRESRX2FFTMEMSEL_muxSel = '1' THEN 
      MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= btfOut2_re_signed;
      MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= btfOut2_im_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= btfOut1_re_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= btfOut1_im_signed;
    ELSE 
      MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= btfOut1_re_signed;
      MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= btfOut1_im_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= btfOut2_re_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= btfOut2_im_signed;
    END IF;
    IF initIC = '1' THEN 
      MINRESRX2FFTMEMSEL_cnt_next <= to_unsigned(16#0000#, 14);
      MINRESRX2FFTMEMSEL_muxSel_next <= '0';
      CASE stage_unsigned IS
        WHEN "0000" =>
          MINRESRX2FFTMEMSEL_cntMax_next <= to_unsigned(16#1FFF#, 14);
        WHEN "1110" =>
          MINRESRX2FFTMEMSEL_cntMax_next <= to_unsigned(16#3FFF#, 14);
        WHEN OTHERS => 
          MINRESRX2FFTMEMSEL_cntMax_next <= MINRESRX2FFTMEMSEL_cntMax srl 1;
      END CASE;
    ELSIF btfOut_vld = '1' THEN 
      IF MINRESRX2FFTMEMSEL_cnt = MINRESRX2FFTMEMSEL_cntMax THEN 
        MINRESRX2FFTMEMSEL_cnt_next <= to_unsigned(16#0000#, 14);
        MINRESRX2FFTMEMSEL_muxSel_next <=  NOT MINRESRX2FFTMEMSEL_muxSel;
      ELSE 
        MINRESRX2FFTMEMSEL_cnt_next <= MINRESRX2FFTMEMSEL_cnt + to_unsigned(16#0001#, 14);
      END IF;
    END IF;
    MINRESRX2FFTMEMSEL_stgOutReg_vld_next <= btfOut_vld;
    stgOut1_re_tmp <= MINRESRX2FFTMEMSEL_stgOut1Reg_re;
    stgOut1_im_tmp <= MINRESRX2FFTMEMSEL_stgOut1Reg_im;
    stgOut2_re_tmp <= MINRESRX2FFTMEMSEL_stgOut2Reg_re;
    stgOut2_im_tmp <= MINRESRX2FFTMEMSEL_stgOut2Reg_im;
    stgOut_vld <= MINRESRX2FFTMEMSEL_stgOutReg_vld;
  END PROCESS MINRESRX2FFTMEMSEL_output;


  stgOut1_re <= std_logic_vector(stgOut1_re_tmp);

  stgOut1_im <= std_logic_vector(stgOut1_im_tmp);

  stgOut2_re <= std_logic_vector(stgOut2_re_tmp);

  stgOut2_im <= std_logic_vector(stgOut2_im_tmp);

END rtl;
