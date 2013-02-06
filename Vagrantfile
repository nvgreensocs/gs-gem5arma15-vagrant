# -*- mode: ruby -*-
# vi: set ft=ruby :

pwd=File.dirname(File.expand_path(__FILE__))
require "#{pwd}/GSProject/GSVagrantFile.rb"

cookbooks=[
  "chef-amba-kit",
  "chef-systemc",
  "chef-greenlib",
  "chef-gem5",
  "chef-ACESlave"
];

versions = "versions";
toplevel = "toplevel";

memory = "2048";

box = "GreenSocsBaseMachine32Bit15Jan13"
#box = "GreenSocsBaseMachine64Bit28Jan13"


GSProject.new(box,cookbooks, versions, toplevel, memory).run 
