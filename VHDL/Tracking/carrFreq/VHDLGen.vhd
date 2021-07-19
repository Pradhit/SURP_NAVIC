
-- VHDL Code for carrFreq block


-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\VHDLGen\VHDLGen.vhd
-- Created: 2021-07-19 11:32:16
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 0
-- Target subsystem base rate: 0
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: VHDLGen
-- Source Path: VHDLGen
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY VHDLGen IS
  PORT( oldNco                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        carrErrorDiff                     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        carrFreq                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En16
        );
END VHDLGen;


ARCHITECTURE rtl OF VHDLGen IS

  -- Component Declarations
  COMPONENT MATLAB_Function
    PORT( oldNco                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          carrErrorDiff                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
          y                               :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En16
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : MATLAB_Function
    USE ENTITY work.MATLAB_Function(rtl);

  -- Signals
  SIGNAL y                                : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_MATLAB_Function : MATLAB_Function
    PORT MAP( oldNco => oldNco,  -- sfix32_En16
              carrErrorDiff => carrErrorDiff,  -- sfix32_En30
              y => y  -- sfix32_En16
              );

  carrFreq <= y;

END rtl;