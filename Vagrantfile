# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "GSProject/GSVagrantFile.rb"

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

#box = "GreenSocsBaseMachine32Bit15Jan13"
box = "GreenSocsBaseMachine26Nov12"

GSProject.new(box,cookbooks, versions, toplevel, memory).run;





