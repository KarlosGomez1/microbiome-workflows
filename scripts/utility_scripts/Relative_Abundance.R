# Function to plot Relative Abundance of Taxonomic Data
## Author: J. Carlos Gomez
### Overview: Shotgun Metagenomic data should be processed and imported into a phyloseq object.  

library(phyloseq)
library(ggplot2)
library(RColorBrewer)

create_bar_plot <- function(phy_obj, taxrank, level, grouping_var, grouping_levels = NULL, output_dir, project_name = "Project") {
  phy_abundance <- tax_glom(phy_obj, taxrank = taxrank)
  top_taxa <- names(sort(taxa_sums(phy_abundance), decreasing = TRUE)[1:10])
  tax_table(phy_abundance)[, taxrank][!rownames(tax_table(phy_abundance)) %in% top_taxa] <- "Other"
  mdf <- psmelt(phy_abundance)
  temp_factors <- levels(factor(mdf[[taxrank]]))
  taxa_factor <- factor(mdf[[taxrank]], levels = c(temp_factors[!temp_factors == "Other"], "Other"))
  mdf[[taxrank]] <- taxa_factor
  if (!grouping_var %in% colnames(sample_data(phy_abundance))) {
    stop(paste("Grouping variable", grouping_var, "not found in sample data."))
  }
  mdf[[grouping_var]] <- sample_data(phy_abundance)[[grouping_var]]
  if (!is.null(grouping_levels)) {
    mdf[[grouping_var]] <- factor(mdf[[grouping_var]], levels = grouping_levels)
  }
  num_taxa <- length(unique(taxa_factor))
  colours <- colorRampPalette(brewer.pal(9, "Set1"))(num_taxa + 1)
  phy_bar_plot <- ggplot(mdf, aes(x = .data[[grouping_var]], y = Abundance, fill = .data[[taxrank]])) +
    stat_summary(fun = mean, geom = "bar", position = "fill") +  
    xlab("") + 
    ylab("Relative Abundance (%)") +
    scale_y_continuous(labels = scales::percent) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 12, face = "bold"),
      axis.title = element_text(size = 16, face = "bold"),
      legend.text = element_text(face = "italic"),
      legend.title = element_text(face = "italic")
    ) +
    scale_fill_manual(values = colours) +  
    guides(fill = guide_legend(title = taxrank, title.theme = element_text(face = "italic"))) +
    ggtitle(paste("Top 10", taxrank, "by", grouping_var))
  output_file <- file.path(output_dir, paste0(project_name, "_Top10_", level, "_", grouping_var, ".pdf"))
  ggsave(output_file, phy_bar_plot, width = 8, height = 6)
  print(phy_bar_plot)
}

