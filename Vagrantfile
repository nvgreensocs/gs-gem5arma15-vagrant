# -*- mode: ruby -*-
# vi: set ft=ruby :

pwd=File.dirname(File.expand_path(__FILE__))
require "#{pwd}/GSProject/GSVagrantfile.rb"

cookbooks=[
  "chef-systemc",
  "chef-greenlib",
  "chef-amba-kit",
  "chef-gem5",
  "chef-ACESlave"
];

versions = "versions";
toplevel = "toplevel";

memory = "2048";

box = "GreenSocsBaseMachine32Bit15Jan13"
#box = "GreenSocsBaseMachine64Bit28Jan13"


GSProject.new(box,cookbooks, versions, toplevel, memory).run 
